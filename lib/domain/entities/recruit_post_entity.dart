import 'package:logger/logger.dart';
import 'package:test_us_app/data/models/user/user_model.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';

import '../../data/models/application/application_model.dart';
import '../../data/models/image/image_model.dart';
import '../../data/models/post/recruit_post_model.dart';
import 'image_entity.dart';

final logger = Logger();
class RecruitReviewEntity {
  String? reviewId;
  String? postId;
  String? reviewerUserId;
  double? rating;

  RecruitReviewEntity({
    this.reviewId,
    this.postId,
    this.reviewerUserId,
    this.rating
  });
}

class RecruitPostEntity {
  String? id;
  String? title;
  String? subtitle;
  ApplicationPlatform? platform;
  List<MobileOsType>? mobileOs;
  PostCategory? category;
  String? contents;
  PostStatus? status;
  int? period;
  int? views;
  List<ImageEntity>? images;
  String? postType;
  List<RecruitReviewEntity>? reviews;
  UserEntity? author;
  List<int>? applications;
  DateTime? createdAt;
  DateTime? updatedAt;

  RecruitPostEntity({
    this.id,
    this.title,
    this.subtitle,
    this.author,
    this.applications,
    this.platform,
    this.mobileOs,
    this.category,
    this.contents,
    this.status,
    this.period,
    this.views,
    this.images,
    this.postType,
    this.reviews,
    this.createdAt,
    this.updatedAt,
  });

  static RecruitPostEntity toPostEntity(RecruitPostModel model) {
    final user = UserEntity(
      id: model.author!.userId,
      nickname: model.author!.nickname,
      profileImg: model.author!.profileImg == null ? null : ImageEntity.toImageEntity(model.author!.profileImg!),
    );
    final images = model.images!.map((e) => ImageEntity.toImageEntity(e)).toList();
    // final applications = model.applications!.map((e) => ApplicationEntity.toEntity(e)).toList();
    final reviews = model.reviews!.map((e) => RecruitReviewEntity(
      reviewId: e.reviewId,
      postId: e.postId,
      reviewerUserId: e.reviewerUserId,
      rating: e.rating
    )).toList();

    return RecruitPostEntity(
      id: model.id,
      title: model.title,
      subtitle: model.subtitle,
      author: user,
      applications: model.applications,
      platform: model.platform,
      mobileOs: model.mobileOs,
      category: model.category,
      contents: model.contents,
      status: model.status,
      period: model.period,
      views: model.views,
      images: images,
      postType: model.postType,
      reviews: reviews,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  static RecruitPostModel toPostModel(RecruitPostEntity entity) {
    final user = UserModel(
      userId: entity.author!.id,
      nickname: entity.author!.nickname,
    );
    final List<ImageModel> images =
        entity.images != null ? entity.images!.map((e) => ImageEntity.toImageModel(e)).toList() : [];
    // final List<ApplicationModel> applications =
    //     entity.applications != null ? entity.applications!.map((e) => ApplicationEntity.toModel(e)).toList() : [];
    return RecruitPostModel(
      id: entity.id,
      title: entity.title,
      subtitle: entity.subtitle,
      author: user,
      applications: entity.applications,
      platform: entity.platform,
      mobileOs: entity.mobileOs,
      category: entity.category,
      contents: entity.contents,
      status: entity.status,
      period: entity.period,
      views: entity.views,
      images: images,
    );
  }
}
