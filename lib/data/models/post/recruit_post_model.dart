import 'package:json_annotation/json_annotation.dart';
import 'package:test_us_app/data/models/review/post_review_model.dart';

import '../application/application_model.dart';
import '../user/user_model.dart';
import '../image/image_model.dart';

part 'recruit_post_model.g.dart';
// part 'recruit_review_model.g.dart';

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

enum PostCategory {
  @JsonValue('game')
  game,
  @JsonValue('travel')
  travel,
  @JsonValue('developer_tool')
  developerTool,
  @JsonValue('health')
  health,
  @JsonValue('education')
  education,
  @JsonValue('finance')
  finance,
  @JsonValue('weather')
  weather,
  @JsonValue('news')
  news,
  @JsonValue('books')
  books,
  @JsonValue('life')
  life,
  @JsonValue('business')
  business,
  @JsonValue('photography')
  photography,
  @JsonValue('social')
  social,
  @JsonValue('shopping')
  shopping,
  @JsonValue('entertainment')
  entertainment,
  @JsonValue('sports')
  sports,
  @JsonValue('utility')
  utility,
  @JsonValue('food')
  food,
  @JsonValue('music')
  music,
  @JsonValue('medical')
  medical,
  @JsonValue('magazine')
  magazine,
  @JsonValue('etc')
  etc,
}

@JsonSerializable()
class RecruitReviewModel {
  String? reviewId;
  String? postId;
  String? reviewerUserId;
  double? rating;

  RecruitReviewModel({
    this.reviewId,
    this.postId,
    this.reviewerUserId,
    this.rating
  });
  factory RecruitReviewModel.fromJson(Map<String, dynamic> json) => _$RecruitReviewModelFromJson(json);
}

@JsonSerializable()
class RecruitPostModel {
  String? id;
  String? title;
  String? subtitle;
  ApplicationPlatform? platform;
  MobileOsType? mobileOs;
  PostCategory? category;
  String? contents;
  PostStatus? status;
  int? period;
  UserModel? author;
  int? views;
  List<ImageModel>? images;
  String? postType;
  List<RecruitReviewModel>? reviews;
  List<int>? applications;
  DateTime? createdAt;
  DateTime? updatedAt;

  RecruitPostModel({
    this.id,
    this.author,
    this.title,
    this.subtitle,
    this.contents,
    this.platform,
    this.mobileOs,
    this.category,
    this.status,
    this.period,
    this.applications,
    this.views,
    this.images,
    this.postType,
    this.reviews,
    this.createdAt,
    this.updatedAt,
  });

  factory RecruitPostModel.fromJson(Map<String, dynamic> json) => _$RecruitPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecruitPostModelToJson(this);
}
