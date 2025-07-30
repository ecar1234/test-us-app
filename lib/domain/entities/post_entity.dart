import '../../data/models/post/post_model.dart';

class PostEntity {
  String? id;
  String? title;
  String? subTitle;
  String? platform;
  String? content;
  PostStatus? status;
  int? period;
  String? author;
  List<String>? applications;
  DateTime? createdAt;
  DateTime? updatedAt;

  PostEntity({
    this.id,
    this.title,
    this.subTitle,
    this.author,
    this.applications,
    this.platform,
    this.content,
    this.status,
    this.period,
    this.createdAt,
    this.updatedAt,
  });
}
