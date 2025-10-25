

import 'package:test_us_app/data/models/post/promotion_post_model.dart';

import '../../data/models/image/image_model.dart';
import '../../data/models/post/recruit_post_model.dart';
import '../../data/models/user/user_model.dart';

class PromotionPostEntity {
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

  PromotionPostEntity({
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

  static PromotionPostEntity toEntity(PromotionPostModel model) {
    return PromotionPostEntity();
  }

  static PromotionPostModel toModel(PromotionPostEntity entity) {
    return PromotionPostModel();
  }

}