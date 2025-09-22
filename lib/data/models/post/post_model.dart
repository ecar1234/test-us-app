import 'package:json_annotation/json_annotation.dart';

import '../user/user_model.dart';
import 'image_model.dart';

part 'post_model.g.dart';

enum PostStatus {
  @JsonValue('active')
  active,
  @JsonValue('end')
  end,
  @JsonValue('expired')
  expired,
  @JsonValue('delete')
  delete
}

@JsonSerializable()
class PostModel {
  String? id;
  String? title;
  String? subtitle;
  List<String>? platform;
  String? contents;
  PostStatus? status;
  int? period;
  UserModel? author;
  int? views;
  List<ImageModel>? images;
  List<String>? applications;
  DateTime? createdAt;
  DateTime? updatedAt;

  PostModel({
    this.id,
    this.author,
    this.title,
    this.subtitle,
    this.contents,
    this.platform,
    this.status,
    this.period,
    this.applications,
    this.views,
    this.images,
    this.createdAt,
    this.updatedAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}
