// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_pagination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostPagiNationModel<T> _$PostPagiNationModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    PostPagiNationModel<T>(
      posts: (json['posts'] as List<dynamic>?)?.map(fromJsonT).toList(),
      page: (json['page'] as num?)?.toInt(),
      isLast: json['isLast'] as bool?,
    );

Map<String, dynamic> _$PostPagiNationModelToJson<T>(
  PostPagiNationModel<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'posts': instance.posts?.map(toJsonT).toList(),
      'page': instance.page,
      'isLast': instance.isLast,
    };
