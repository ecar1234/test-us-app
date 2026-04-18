
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../data/models/purchase/purchase_model.dart';

class PurchaseEntity {
  int? id;
  String? plan;
  String? period;
  String? productId;
  bool? isActive;
  bool? willRenew;
  String? paidStore;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? expireDate;

  PurchaseEntity({
    this.id,
    this.plan,
    this.period,
    this.productId,
    this.isActive,
    this.willRenew,
    this.paidStore,
    this.createdAt,
    this.updatedAt,
    this.expireDate,
  });

  static PurchaseEntity toEntity(PurchaseModel model) {
    return PurchaseEntity(
      id: model.id,
      plan: model.plan,
      period: model.period,
      productId: model.productId,
      isActive: model.isActive,
      willRenew: model.willRenew,
      paidStore: model.paidStore,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      expireDate: model.expireDate,
    );
  }
}
