import '../../data/models/post/post_model.dart';

class PostEntity {
  String? id;
  String? title;
  String? subtitle;
  List<String>? platform;
  String? contents;
  PostStatus? status;
  int? period;
  String? author;
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
    this.createdAt,
    this.updatedAt,
  });

  static PostEntity toPostEntity(PostModel model){
    return PostEntity(
      id: model.postId,
      title: model.title,
      subtitle: model.subtitle,
      author: model.author,
      applications: model.applications,
      platform: model.platform,
      contents: model.contents,
      status: model.status
    );
  }
  static PostModel toPostModel(PostEntity entity){
    return PostModel(
      postId: entity.id,
      title: entity.title,
      subtitle: entity.subtitle,
      author: entity.author,
      applications: entity.applications,
      platform: entity.platform,
      contents: entity.contents,
      status: entity.status
    );
  }
}
