
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/domain/entities/purchase_entity.dart';

import '../../domain/entities/product_entity.dart';

class PurchaseProvider with ChangeNotifier {
  final logger = Logger();

  List<ProductEntity> _products = [];
  // List<PurchaseDetails> _purchases = [];
  List<PurchaseEntity> _subscribedList = [];
  PurchaseDetails? _pendingPurchase;

  List<ProductEntity> get products => _products;
  // List<PurchaseDetails> get purchases => _purchases;
  List<PurchaseEntity> get subscribedList => _subscribedList;
  PurchaseDetails? get pendingPurchase => _pendingPurchase;

  void getUserPurchaseList(List<PurchaseEntity> purchases) {
    _subscribedList = purchases;
    notifyListeners();
  }

  void getProducts(List<ProductEntity> products) {
    _products = products;
    notifyListeners();
  }

  void updatePurchaseByServer (PurchaseEntity purchase) {
    final old = _subscribedList.firstWhereOrNull((e) => e.isActive == true);
    if(old != null){
      _subscribedList.remove(old);
      old.isActive = false;
      _subscribedList = [..._subscribedList, old, purchase];
    }else {
      _subscribedList = [..._subscribedList, purchase];
    }
    notifyListeners();
  }
}
