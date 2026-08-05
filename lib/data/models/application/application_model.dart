import 'package:json_annotation/json_annotation.dart';
import 'package:test_us_app/data/models/post/recruit_post_model.dart';

part 'application_model.g.dart';

enum ApplicationPlatform {
  @JsonValue('web')
  web,
  @JsonValue('mobile')
  mobile,
}

enum MobileOsType {
  @JsonValue('ios')
  ios,
  @JsonValue('android')
  android,
}

enum ApplicationStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('rejected')
  rejected,
  @JsonValue('cancel')
  cancel
}

@JsonSerializable()
class ApplicationModel {
  int? id;
  ApplicationPlatform? platform;
  MobileOsType? mobileOs;
  ApplicationStatus? status;
  DateTime? appliedAt;
  DateTime? updatedAt;
  PostInfoModel? postInfo;
  String? applicantId;

  ApplicationModel({
    this.id,
    this.platform,
    this.mobileOs,
    this.status,
    this.appliedAt,
    this.updatedAt,
    this.postInfo,
    this.applicantId,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) => _$ApplicationModelFromJson(json);

  Map<String, dynamic> toJson() {
    final map = _$ApplicationModelToJson(this);
    if (postInfo != null) {
      map['postId'] = postInfo!.postId;
    }
    map.remove('postInfo');

    return map;
  }
}

@JsonSerializable()
class PostInfoModel {
  String? postId;
  String? title;
  String? thumbnailUrl;
  bool? isExpired;
  PostCategory? category;

  PostInfoModel({this.postId, this.title, this.thumbnailUrl, this.isExpired, this.category});

  factory PostInfoModel.fromJson(Map<String, dynamic> json) => _$PostInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostInfoModelToJson(this);
}
