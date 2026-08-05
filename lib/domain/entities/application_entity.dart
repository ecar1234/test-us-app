import 'package:test_us_app/data/models/post/recruit_post_model.dart';

import '../../data/models/application/application_model.dart';

class ApplicationEntity {
  int? id;
  ApplicationPlatform? platform;
  MobileOsType? mobileOs;
  ApplicationStatus? status;
  DateTime? appliedAt;
  DateTime? updatedAt;
  PostInfo? postInfo;
  String? applicantId;

  ApplicationEntity({
    this.id,
    this.platform,
    this.mobileOs,
    this.status,
    this.appliedAt,
    this.updatedAt,
    this.postInfo,
    this.applicantId,
  });

  static ApplicationEntity toEntity(ApplicationModel model) {
    final postInfo = PostInfo.toEntity(model.postInfo!);
    return ApplicationEntity(
      id: model.id,
      platform: model.platform,
      mobileOs: model.mobileOs,
      status: model.status,
      appliedAt: model.appliedAt,
      updatedAt: model.updatedAt,
      postInfo: postInfo,
      applicantId: model.applicantId,
    );
  }

  static ApplicationModel toModel(ApplicationEntity entity) {
    final postInfo = PostInfo.toModel(entity.postInfo!);
    return ApplicationModel(
      id: entity.id,
      platform: entity.platform,
      mobileOs: entity.mobileOs,
      status: entity.status,
      appliedAt: entity.appliedAt,
      updatedAt: entity.updatedAt,
      postInfo: postInfo,
      applicantId: entity.applicantId,
    );
  }
}

class PostInfo {
  String? title;
  String? postId;
  String? thumbnailUrl;
  bool? isExpired;
  PostCategory? category;

  PostInfo({
    this.title,
    this.postId,
    this.thumbnailUrl,
    this.isExpired,
    this.category
  });
  static PostInfo toEntity(PostInfoModel model) {

    return PostInfo(
      title: model.title,
      postId: model.postId,
      thumbnailUrl: model.thumbnailUrl,
      isExpired: model.isExpired,
      category: model.category
    );
  }
  static PostInfoModel toModel(PostInfo entity) {
    return PostInfoModel(
      postId: entity.postId,
    );
  }
}
