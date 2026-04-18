
import 'package:json_annotation/json_annotation.dart';

part 'purchase_model.g.dart';


@JsonSerializable()
class PurchaseModel {
  int? id;
  String? plan;
  String? period;
  String? productId;
  bool? isActive;
  bool? willRenew;
  String? paidStore;
  DateTime? expireDate;
  DateTime? createdAt;
  DateTime? updatedAt;

  PurchaseModel({
    this.id,
    this.plan,
    this.period,
    this.productId,
    this.isActive,
    this.willRenew,
    this.paidStore,
    this.expireDate,
    this.createdAt,
    this.updatedAt,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) => _$PurchaseModelFromJson(json);
}