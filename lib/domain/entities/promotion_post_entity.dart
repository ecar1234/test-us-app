import 'package:test_us_app/data/models/post/promotion_post_model.dart';
import 'package:test_us_app/domain/entities/image_entity.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';
import '../../data/models/post/recruit_post_model.dart';


class PromotionPostEntity {
  String? id;
  String? title;
  String? subtitle;
  List<String>? platform;
  String? contents;
  PostStatus? status;
  int? period;
  UserEntity? author;
  int? views;
  List<ImageEntity>? images;
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