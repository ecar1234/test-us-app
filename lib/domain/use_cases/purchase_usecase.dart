import 'dart:convert';

import 'package:purchases_flutter/purchases_flutter.dart';

import '../repositories/purchase_repository.dart';

class PurchaseUseCase {
  final PurchaseRepository _repository;

  PurchaseUseCase(this._repository);

  Future<void> eventLog(EntitlementInfo info) async {
    Map<String, dynamic> data = {
      'productIdentifier': info.productIdentifier,
      'productPlanIdentifier': info.productPlanIdentifier,
      'identifier': info.identifier,
      'isActive': info.isActive,
      'willRenew': info.willRenew,
      'originalPurchaseDate': info.originalPurchaseDate,
      'expirationDate': info.expirationDate,
      'store': info.store.name,
    };

    await _repository.eventLog(jsonEncode(data));
  }

  Future<void> errorLog(String errorInfo) async {
    await _repository.errorLog(errorInfo);
  }

  Future<void> refresh(CustomerInfo info) async {
    await _repository.refresh(info);
  }


}