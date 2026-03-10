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
    final plan = info.productPlanIdentifier?.split('-');
    return PurchaseEntity(
      plan: info.identifier.split(' ')[0] , // android : standard / premium , ios :
      period: plan?[1]??"", // 1m / 3m / 6m / 12m
      planId: info.productPlanIdentifier, // ex. standard-1m-price
      isActive: info.isActive,
      willRenew: info.willRenew,
      paidStore: info.store.name,
      startDate: info.originalPurchaseDate,
      expireDate: info.expirationDate,
    );
  }
}
