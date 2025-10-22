// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageModel _$ImageModelFromJson(Map<String, dynamic> json) => ImageModel(
      id: (json['id'] as num?)?.toInt(),
      filename: json['filename'] as String?,
      originalname: json['originalname'] as String?,
      mimetype: json['mimetype'] as String?,
      size: (json['size'] as num?)?.toInt(),
      url: json['url'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ImageModelToJson(ImageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'filename': instance.filename,
      'originalname': instance.originalname,
      'mimetype': instance.mimetype,
      'size': instance.size,
      'url': instance.url,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
