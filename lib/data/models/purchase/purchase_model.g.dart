// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseModel _$PurchaseModelFromJson(Map<String, dynamic> json) =>
    PurchaseModel(
      id: (json['id'] as num?)?.toInt(),
      plan: json['plan'] as String?,
      period: json['period'] as String?,
      productId: json['productId'] as String?,
      isActive: json['isActive'] as bool?,
      willRenew: json['willRenew'] as bool?,
      paidStore: json['paidStore'] as String?,
      expireDate: json['expireDate'] == null
          ? null
          : DateTime.parse(json['expireDate'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PurchaseModelToJson(PurchaseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plan': instance.plan,
      'period': instance.period,
      'productId': instance.productId,
      'isActive': instance.isActive,
      'willRenew': instance.willRenew,
      'paidStore': instance.paidStore,
      'expireDate': instance.expireDate?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
