


import 'package:json_annotation/json_annotation.dart';
import 'package:test_us_app/data/models/post/recruit_post_model.dart';

import '../image/image_model.dart';
import '../user/user_model.dart';

part 'promotion_post_model.g.dart';

@JsonSerializable()
class PromotionPostModel {
  String? id;
  String? title;
  String? subtitle;
  List<String>? platform;
  String? contents;
  PostStatus? status;
  int? period;
  UserModel? author;
  int? views;
  List<ImageModel>? images;
  List<String>? domain;
  DateTime? createdAt;
  DateTime? updatedAt;

  PromotionPostModel({
    this.id,
    this.title,
    this.subtitle,
    this.platform,
    this.contents,
    this.status,
    this.period,
    this.author,
    this.views,
    this.images,
    this.domain,
    this.createdAt,
    this.updatedAt,
  });

  factory PromotionPostModel.fromJson(Map<String, dynamic> json) => _$PromotionPostModelFromJson(json);
  Map<String, dynamic> toJson() => _$PromotionPostModelToJson(this);
}
