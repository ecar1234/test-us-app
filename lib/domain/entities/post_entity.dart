import 'package:test_us_app/data/models/user/user_model.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';

import '../../data/models/application/application_model.dart';
import '../../data/models/post/image_model.dart';
import '../../data/models/post/post_model.dart';
import 'application_entity.dart';
import 'image_entity.dart';

class PostEntity {
  String? id;
  String? title;
  String? subtitle;
  List<String>? platform;
  String? contents;
  PostStatus? status;
  int? period;
  int? views;
  List<ImageEntity>? images;
  UserEntity? author;
  List<ApplicationEntity>? applications;
  DateTime? createdAt;
  DateTime? updatedAt;

  PostEntity({
    this.id,
    this.title,
    this.subtitle,
    this.author,
    this.applications,
    this.platform,
    this.contents,
    this.status,
    this.period,
    this.views,
    this.images,
    this.createdAt,
    this.updatedAt,
  });

  static PostEntity toPostEntity(PostModel model){
    final user = UserEntity(
      id: model.author!.userId,
      nickname: model.author!.nickname,
    );
    final images = model.images!.map((e) => ImageEntity.toImageEntity(e)).toList();
    final applications = model.applications!.map((e) => ApplicationEntity.toEntity(e)).toList();
    return PostEntity(
      id: model.id,
      title: model.title,
      subtitle: model.subtitle,
      author: user,
      applications: applications,
      platform: model.platform,
      contents: model.contents,
      status: model.status,
      period: model.period,
      views: model.views,
      images: images,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
  static PostModel toPostModel(PostEntity entity){
    final user = UserModel(
      userId: entity.author!.id,
      nickname: entity.author!.nickname,
    );
    final List<ImageModel> images = entity.images != null ? entity.images!.map((e) => ImageEntity.toImageModel(e)).toList() : [];
    final List<ApplicationModel> applications = entity.applications != null ? entity.applications!.map((e) => ApplicationEntity.toModel(e)).toList() : [];
    return PostModel(
      id: entity.id,
      title: entity.title,
      subtitle: entity.subtitle,
      author: user,
      applications: applications,
      platform: entity.platform,
      contents: entity.contents,
      status: entity.status,
      period: entity.period,
      views: entity.views,
      images: images
    );
  }
}
