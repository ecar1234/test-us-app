import 'package:json_annotation/json_annotation.dart';

part 'application_model.g.dart';

enum ApplicationPlatform {
  @JsonValue('PENDING')
  pending,
  @JsonValue('ACCEPTED')
  accepted,
  @JsonValue('REJECTED')
  rejected,
}

enum ApplicationStatus {
  @JsonValue('ACTIVE')
  active,
  @JsonValue('END')
  end,
  @JsonValue('EXPIRED')
  expired
}

@JsonSerializable()
class ApplicationModel {
  String? appId;
  ApplicationPlatform? platform;
  ApplicationStatus? status;
  DateTime? appliedAt;
  DateTime? updatedAt;
  String? postId;
  String? appUserId;

  ApplicationModel({
    this.appId,
    this.platform,
    this.status,
    this.appliedAt,
    this.updatedAt,
    this.postId,
    this.appUserId,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) => _$ApplicationModelFromJson(json);
  Map<String, dynamic> toJson() => _$ApplicationModelToJson(this);
}