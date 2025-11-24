import 'package:test_us_app/data/models/post/promotion_post_model.dart';
import 'package:test_us_app/domain/entities/image_entity.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';
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
  UserEntity? author;
  int? views;
  List<ImageEntity>? images;
  List<String>? domain;
  String? postType;
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
    this.postType,
    this.createdAt,
    this.updatedAt,
  });

  static PromotionPostEntity toEntity(PromotionPostModel model) {
    final user = UserEntity(
      id: model.author!.userId,
      nickname: model.author!.nickname,
      profileImg: ImageEntity.toImageEntity(model.author!.profileImg!),
    );
    final images = model.images!.map((e) => ImageEntity.toImageEntity(e)).toList();
    return PromotionPostEntity(
      id: model.id,
      title: model.title,
      subtitle: model.subtitle,
      platform: model.platform,
      contents: model.contents,
      status: model.status,
      period: model.period,
      author: user,
      views: model.views,
      images: images,
      domain: model.domain,
      postType: model.postType,
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