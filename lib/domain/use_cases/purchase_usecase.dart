import 'dart:io';

import 'package:flutter/material.dart';
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
    'std_m1',
    'std_3m',
    'std_6m',
    'std_1y',
    'pre_m1',
    'pre_3m',
    'pre_6m',
    'pre_1y',
  ];

  Future<void> eventLog(String testWord) async {
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

    await _repository.eventLog(testWord);
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
      debugPrint('실패한 상품 IDs: ${res.notFoundIDs}');
      // 여기서 return [] 을 하지 말고 계속 진행합니다.
    }
    if (res.productDetails.isEmpty) {
      debugPrint('상품이 없습니다: ${res.productDetails}');
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

        String inferredPeriod = '';
        if (product.id.contains('m1')) inferredPeriod = 'P1M';
        if (product.id.contains('1y')) inferredPeriod = 'P1Y';
        if (product.id.contains('3m')) inferredPeriod = 'P3M';
        if (product.id.contains('6m')) inferredPeriod = 'P6M';

        try {
          return ProductEntity(
            id: product.id,
            groupId: product.id,
            title: product.title,
            description: product.description,
            price: product.price,
            rawPrice: product.rawPrice,
            currencyCode: product.currencyCode,
            period: inferredPeriod, // UI가 이 값을 기다리고 있을 가능성이 높음
            originProduct: product,
            offerToken: null,
          );
        } catch (e) {
          debugPrint('변환 중 에러 발생: $e');
          return null; // 실패한 녀석은 null로 보냄
        }
      }).whereType<ProductEntity>().toList(); // null 제거

      debugPrint('[최종 반환] 변환 완료된 상품 수: ${offers.length}');
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

  Future<bool> purchaseUpdateByAos(ProductDetails product, String productId, PurchaseDetails old) async {
    final convertOld = old as GooglePlayPurchaseDetails;
    if (convertOld.purchaseID == null) throw Exception('invalid old purchase');

    final offerToken = (product as GooglePlayProductDetails).productDetails.subscriptionOfferDetails!
        .firstWhere((e) => e.basePlanId == productId).offerIdToken;

    // NOTE: 테스트 시에는 시간압축으로 인해서 MODE 변경에 따른 오류가 발생.
    // NOTE: 테스트 진행 시 proration은 chargeFullPrice 또는 deferred로 고정 후 진행.
    final grade = _checkProrationMode(old, product);
    // final proration = grade == 1
    //     ? ReplacementMode.deferred : ReplacementMode.withTimeProration;
    final proration =  ReplacementMode.chargeFullPrice;


    final param = GooglePlayPurchaseParam(
      productDetails: product,
      changeSubscriptionParam: ChangeSubscriptionParam(
        replacementMode: proration,
        oldPurchaseDetails: convertOld,
      ),
      offerToken: offerToken,
    );
    final res = await _inAppPurchase.buyNonConsumable(purchaseParam: param);
    return res;
  }
  Future<bool> purchaseByIos(ProductDetails product) async {
    final purchaseParam = PurchaseParam(
      productDetails: product,
    );
    final res = await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    return res;
  }

  Future<PurchaseEntity> verifyPurchase(String token, String userId, PurchaseDetails purchase) async {
    Map<String, String> req = {};
    PurchaseEntity res;
    req['userId'] = userId;
    if(purchase.verificationData.source == 'google_play'){
      req['token'] = purchase.verificationData.serverVerificationData;
      res = await _repository.verifyPurchaseAOS(token, userId, req);
    }else {
      req['transactionId'] = purchase.purchaseID!;
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