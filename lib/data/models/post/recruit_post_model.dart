import 'package:json_annotation/json_annotation.dart';

import '../application/application_model.dart';
import '../user/user_model.dart';
import '../image/image_model.dart';

part 'recruit_post_model.g.dart';

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
class RecruitPostModel {
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
  List<ApplicationModel>? applications;
  DateTime? createdAt;
  DateTime? updatedAt;

  RecruitPostModel({
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

  factory RecruitPostModel.fromJson(Map<String, dynamic> json) => _$RecruitPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecruitPostModelToJson(this);
}
