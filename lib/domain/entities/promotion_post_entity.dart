import 'package:test_us_app/data/models/application/application_model.dart';
import 'package:test_us_app/data/models/post/promotion_post_model.dart';
import 'package:test_us_app/domain/entities/image_entity.dart';
import 'package:test_us_app/domain/entities/post_review_entity.dart';
import 'package:test_us_app/domain/entities/user_review_entity.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';
import '../../data/models/image/image_model.dart';
import '../../data/models/post/recruit_post_model.dart';
import '../../data/models/user/user_model.dart';


class PromotionPostEntity {
  String? id;
  String? title;
  String? subtitle;
  ApplicationPlatform? platform;
  List<MobileOsType>? mobileOs;
  PostCategory? category;
  String? contents;
  PostStatus? status;
  int? period;
  UserEntity? author;
  int? views;
  List<ImageEntity>? images;
  List<String>? domain;
  String? postType;
  List<String>? reviews;
  DateTime? createdAt;
  DateTime? updatedAt;

  PromotionPostEntity({
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

  static PromotionPostEntity toEntity(PromotionPostModel model) {
    final user = UserEntity(
      id: model.author!.userId,
      nickname: model.author!.nickname,
      profileImg: model.author!.profileImg == null ? null : ImageEntity.toImageEntity(model.author!.profileImg!),
      status: model.author!.status,
    );
    final images = model.images!.map((e) => ImageEntity.toImageEntity(e)).toList();
    // final reviews = model.reviews!.map((e) => PostReviewEntity.toEntity(e)).toList();
    return PromotionPostEntity(
      id: model.id,
      title: model.title,
      subtitle: model.subtitle,
      platform: model.platform,
      mobileOs: model.mobileOs,
      category: model.category,
      contents: model.contents,
      status: model.status,
      period: model.period,
      author: user,
      views: model.views,
      images: images,
      domain: model.domain,
      postType: model.postType,
      reviews: model.reviews,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt
    );
  }

  static PromotionPostModel toModel(PromotionPostEntity entity) {
    final user = UserModel(
      userId: entity.author!.id,
      nickname: entity.author!.nickname,
    );
    final List<ImageModel> images = entity.images != null ? entity.images!.map((e) => ImageEntity.toImageModel(e)).toList() : [];
    return PromotionPostModel(
      id: entity.id,
      title: entity.title,
      subtitle: entity.subtitle,
      platform: entity.platform,
      mobileOs: entity.mobileOs,
      category: entity.category,
      contents: entity.contents,
      status: entity.status,
      period: entity.period,
      author: user,
      views: entity.views,
      images: images,
      domain: entity.domain,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt
    );
  }

}