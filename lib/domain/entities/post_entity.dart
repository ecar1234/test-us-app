import 'package:test_us_app/data/models/user/user_model.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';

import '../../data/models/post/post_model.dart';

class PostEntity {
  String? id;
  String? title;
  String? subtitle;
  List<String>? platform;
  String? contents;
  PostStatus? status;
  int? period;
  int? views;
  List<Map<String, dynamic>>? images;
  UserEntity? author;
  List<String>? applications;
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
    return PostEntity(
      id: model.id,
      title: model.title,
      subtitle: model.subtitle,
      author: user,
      applications: model.applications,
      platform: model.platform,
      contents: model.contents,
      status: model.status,
      period: model.period,
      views: model.views,
      images: model.images,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
  static PostModel toPostModel(PostEntity entity){
    final user = UserModel(
      userId: entity.author!.id,
      nickname: entity.author!.nickname,
    );
    return PostModel(
      id: entity.id,
      title: entity.title,
      subtitle: entity.subtitle,
      author: user,
      applications: entity.applications,
      platform: entity.platform,
      contents: entity.contents,
      status: entity.status,
      period: entity.period,
      views: entity.views,
      images: entity.images
    );
  }
}
