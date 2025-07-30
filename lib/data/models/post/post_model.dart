import 'package:json_annotation/json_annotation.dart';

part 'post_model.g.dart';

enum PostStatus {
  @JsonValue('ACTIVE')
  active,
  @JsonValue('END')
  end,
  @JsonValue('EXPIRED')
  expired
}

@JsonSerializable()
class PostModel {
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

  PostModel({
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

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}
