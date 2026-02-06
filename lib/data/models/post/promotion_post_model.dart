import 'package:json_annotation/json_annotation.dart';
import 'package:test_us_app/data/models/post/recruit_post_model.dart';

import '../application/application_model.dart';
import '../image/image_model.dart';
import '../user/user_model.dart';

part 'promotion_post_model.g.dart';

@JsonSerializable()
class PromotionPostModel {
  String? id;
  String? title;
  String? subtitle;
  ApplicationPlatform? platform;
  List<MobileOsType>? mobileOs;
  PostCategory? category;
  String? contents;
  PostStatus? status;
  int? period;
  UserModel? author;
  int? views;
  List<ImageModel>? images;
  List<String>? domain;
  String? postType;
  List<String>? reviews;
  DateTime? createdAt;
  DateTime? updatedAt;

  PromotionPostModel({
    this.id,
    this.title,
    this.subtitle,
    this.platform,
    this.mobileOs,
    this.category,
    this.contents,
    this.status,
    this.period,
    this.author,
    this.views,
    this.images,
    this.domain,
    this.postType,
    this.reviews,
    this.createdAt,
    this.updatedAt,
  });

  factory PromotionPostModel.fromJson(Map<String, dynamic> json) => _$PromotionPostModelFromJson(json);
  Map<String, dynamic> toJson() => _$PromotionPostModelToJson(this);
}
