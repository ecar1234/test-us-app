import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../domain/entities/purchase_entity.dart';

class PurchasesManagements with ChangeNotifier {
  final logger = Logger();
  PurchaseEntity? _subscribedItem;
  PurchaseEntity? get subscribedItem => _subscribedItem;

  List<Package>? _packages;
  List<Package>? get packages => _packages;

  Future<void> addUpdateListenerRevenueCat() async {
    // Purchases.setLogLevel(LogLevel.debug);// Platform-specific API keys
    logger.i('[Purchase] addCustomerInfoUpdateListener');
    Purchases.addCustomerInfoUpdateListener((CustomerInfo customerInfo) {
      final entitlement = customerInfo.entitlements.all.values.where((info) => info.isActive).toList();

      if(entitlement.isNotEmpty && entitlement.length == 1){
        _subscribedItem = PurchaseEntity.toEntity(entitlement[0]);
        notifyListeners();
      }
    });
  }

  void login(String userId) async {
    final loginRes = await Purchases.logIn(userId);
    if(_subscribedItem == null){
      if(loginRes.customerInfo.entitlements.active.values.length == 1) {
        _subscribedItem = PurchaseEntity.toEntity(loginRes.customerInfo.entitlements.active.values.first);
        notifyListeners();
      }else if(loginRes.customerInfo.entitlements.active.values.length > 1){
        final activeItem = loginRes.customerInfo.entitlements.active.values.where((item) => item.isActive).toList();
        _subscribedItem = PurchaseEntity.toEntity(activeItem.first);
      }
    }
  }

  void getOfferings(List<Package> packages) async {
    _packages = packages;
    notifyListeners();
  }

  Future<void> purchase(PurchaseEntity entity) async {
    _subscribedItem = entity;
    notifyListeners();
  }

  Future<void> restore() async {
    await Purchases.restorePurchases();
  }

  Future<void> logout() async {
    await Purchases.logOut();
  }

}
