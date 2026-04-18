import 'dart:convert';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:test_us_app/domain/entities/product_entity.dart';

import '../entities/purchase_entity.dart';
import '../repositories/purchase_repository.dart';

class PurchaseUseCase {
  final PurchaseRepository _repository;
  final InAppPurchase _inAppPurchase;

  PurchaseUseCase(this._repository, this._inAppPurchase);

  final _iProductIds = <String>[
    'std_1m',
    'std_3m',
    'std_6m',
    'std_1y',
    'pre_1m',
    'pre_3m',
    'pre_6m',
    'pre_1y',
  ];

  Future<void> eventLog() async {
    // Map<String, dynamic> data = {
    //   'productIdentifier': info.productIdentifier,
    //   'productPlanIdentifier': info.productPlanIdentifier,
    //   'identifier': info.identifier,
    //   'isActive': info.isActive,
    //   'willRenew': info.willRenew,
    //   'originalPurchaseDate': info.originalPurchaseDate,
    //   'expirationDate': info.expirationDate,
    //   'store': info.store.name,
    // };

    await _repository.eventLog();
  }

  Future<void> errorLog(String errorInfo) async {
    await _repository.errorLog(errorInfo);
  }

  Future<void> refresh() async {
    await _repository.refresh();
  }

  Future<List<ProductEntity>> getProducts() async {
    final List<String> productIds = Platform.isAndroid ? ['purchase'] : _iProductIds;
    final ProductDetailsResponse res = await _inAppPurchase.queryProductDetails(productIds.toSet());
    if (res.notFoundIDs.isNotEmpty) {
      return [];
    }

    if (Platform.isAndroid) {
      final List<ProductEntity> allOffers = [];

      for (var i = 0; i < res.productDetails.length ; i++) {
        final googleProduct = res.productDetails[i] as GooglePlayProductDetails;
        final offer = googleProduct.productDetails.subscriptionOfferDetails!
            .firstWhere((e) => e.pricingPhases.first.formattedPrice == googleProduct.price);
        final pricing = offer.pricingPhases.first;
        final product = ProductEntity(
          id: offer.basePlanId, // 'std-1m', 'pre-1m' 등
          groupId: googleProduct.id, // 'purchase'
          title: _getProductTitle(offer.basePlanId),
          description: googleProduct.description,
          price: pricing.formattedPrice,
          rawPrice: pricing.priceAmountMicros / 1000000,
          currencyCode: pricing.priceCurrencyCode,
          period: pricing.billingPeriod,
          originProduct: googleProduct,
          offerToken: offer.offerIdToken,
        );
        allOffers.add(product);
      }
      return allOffers;
    }
    else {
      final offers = res.productDetails.map((product) {
        return ProductEntity(
          id: product.id, // iOS는 productId 자체가 고유함
          groupId: product.id, // iOS는 그룹 개념이 코드상에선 약함
          title: product.title,
          description: product.description,
          price: product.price,
          rawPrice: product.rawPrice,
          currencyCode: product.currencyCode,
          period: '', // iOS 주기를 ISO 형식으로 변환 필요
          originProduct: product,
          offerToken: null, // iOS는 토큰 개념 없음
        );
      }).toList();
      return offers;
    }
  }

  Future<bool> newPurchaseByAos(ProductDetails product)async{
    final param = GooglePlayPurchaseParam(
      productDetails: product as GooglePlayProductDetails,
    );
    final res = await _inAppPurchase.buyNonConsumable(purchaseParam: param);
    return res;
  }

  Future<void> prepareUpdate()async{
     await _inAppPurchase.restorePurchases();
  }

  Future<bool> purchaseUpdateByAos(ProductDetails product, PurchaseDetails old) async {
    final convertOld = old as GooglePlayPurchaseDetails;
    final grade = _checkProrationMode(old, product);
    final proration = grade == 0
        ? ReplacementMode.withTimeProration
        : (grade == -1 ? ReplacementMode.withTimeProration : ReplacementMode.deferred);

    final param = GooglePlayPurchaseParam(
      productDetails: product,
      changeSubscriptionParam: ChangeSubscriptionParam(
        replacementMode: proration,
        oldPurchaseDetails: convertOld,
      ),
    );

    final res = await _inAppPurchase.buyNonConsumable(purchaseParam: param);
    return res;
  }
  Future<bool> purchaseByIos() async {
    return false;
  }

  Future<PurchaseEntity> verifyPurchase(String token, String userId, PurchaseDetails purchase) async {
    Map<String, String> req = {};
    PurchaseEntity res;
    req['userId'] = userId;
    req['token'] = purchase.verificationData.serverVerificationData;
    if(purchase.verificationData.source == 'google_play'){
      res = await _repository.verifyPurchaseAOS(token, userId, req);
    }else {
      res = await _repository.verifyPurchaseIOS(token, userId, req);
    }
    if(res.isActive == true && purchase.pendingCompletePurchase){
        await _inAppPurchase.completePurchase(purchase);
    }
    return res;
  }

  Future<List<PurchaseEntity>> getPurchaseList(String token, String userId) async {
    final res = await _repository.getPurchaseList(token, userId);
    return res;
  }

  String _getProductTitle(String basePlanId) {
    switch (basePlanId) {
      case 'std-1m' || 'sdt_1m':
        return 'Standard 1개월 구독';
      case 'std-3m' || 'sdt_3m':
        return 'Standard 3개월 구독';
      case 'std-6m' || 'sdt_6m':
        return 'Standard 6개월 구독';
      case 'std-1y' || 'sdt_1y':
        return 'Standard 1년 구독';
      case 'pre-1m' || 'pre_1m':
        return 'Premium 1개월 구독';
      case 'pre-3m' || 'pre_3m':
        return 'Premium 3개월 구독';
      case 'pre-6m' || 'pre_6m':
        return 'Premium 6개월 구독';
      case 'pre-1y' || 'pre_1y':
        return 'Premium 1년 구독';
      default: return '';
    }
  }
  int _checkProrationMode(PurchaseDetails prevPurchase, ProductDetails newPackage) {
    // 2. 현재 플랜과 새 플랜의 가중치 비교
    int currentPlan = 0; // 0: none, 1: standard, 2: premium
    int newPlan = 0; // 0: 0: none, 1: standard, 2: premium

    if (prevPurchase.purchaseID!.contains('std')) {
      currentPlan = 1;
    } else {
      currentPlan = 2;
    }
    if (newPackage.id.contains('std')) {
      newPlan = 1;
    } else {
      newPlan = 2;
    }

    return currentPlan - newPlan;
  }
}