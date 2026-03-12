import 'dart:io';

import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseEntity {
  String? plan;
  String? period;
  String? planId;
  bool? isActive;
  bool? willRenew;
  String? paidStore;
  String? startDate;
  String? expireDate;

  PurchaseEntity({
    this.plan,
    this.period,
    this.planId,
    this.isActive,
    this.willRenew,
    this.paidStore,
    this.startDate,
    this.expireDate,
  });

  static PurchaseEntity toEntity(EntitlementInfo info) {
    // debugPrint('entitlementInfo : identifier: ${info.identifier} '
    //     '/ productIdentifier: ${info.productIdentifier} '
    //     '/ productPlanIdentifier: ${info.productPlanIdentifier} '
    //     '/ isActive: ${info.isActive}'
    //     '/ willRenew: ${info.willRenew} '
    //     '/ originalPurchaseDate: ${info.originalPurchaseDate} '
    //     '/ expirationDate: ${info.expirationDate} '
    //     '/ store: ${info.store.name}'
    //     '/ productPlanIdentifier: ${info.productPlanIdentifier}'
    // );
    if (Platform.isAndroid) {
      final plan = info.productPlanIdentifier?.split('-');
      return PurchaseEntity(
        plan: info.identifier.split(' ')[0], // standard / premium
        period: plan?.last ?? "", // 1m / 3m / 6m / 1y
        planId: info.productPlanIdentifier, // ex. std-1m
        isActive: info.isActive,
        willRenew: info.willRenew,
        paidStore: info.store.name,
        startDate: info.originalPurchaseDate,
        expireDate: info.expirationDate,
      );
    } else {
      return PurchaseEntity(
        plan: info.identifier, // standard / premium
        period: info.productPlanIdentifier?.split('_')[1], // 1m / 3m / 6m / 1y
        planId: info.productPlanIdentifier, // ex. std_1m
        isActive: info.isActive,
        willRenew: info.willRenew,
        paidStore: info.store.name,
        startDate: info.originalPurchaseDate,
        expireDate: info.expirationDate,
      );
    }
  }
}
