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
    this.createdAt,
    this.updatedAt,
  });

  static PostEntity toPostEntity(PostModel model){
    final user = UserEntity(
      id: model.author!.userId,
      nickname: model.author!.nickname,
    );
    return PostEntity(
      id: model.postId,
      title: model.title,
      subtitle: model.subtitle,
      author: user,
      applications: model.applications,
      platform: model.platform,
      contents: model.contents,
      status: model.status
    );
  }
  static PostModel toPostModel(PostEntity entity){
    final user = UserModel(
      userId: entity.author!.id,
      nickname: entity.author!.nickname,
    );
    return PostModel(
      postId: entity.id,
      title: entity.title,
      subtitle: entity.subtitle,
      author: user,
      applications: entity.applications,
      platform: entity.platform,
      contents: entity.contents,
      status: entity.status
    );
  }
}
