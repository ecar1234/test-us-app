import 'package:json_annotation/json_annotation.dart';

part 'application_model.g.dart';

enum ApplicationPlatform {
  @JsonValue('web')
  web,
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
  ApplicationStatus? status;
  DateTime? appliedAt;
  DateTime? updatedAt;
  String? postId;
  String? applicantId;

  ApplicationModel({
    this.id,
    this.platform,
    this.status,
    this.appliedAt,
    this.updatedAt,
    this.postId,
    this.applicantId,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) => _$ApplicationModelFromJson(json);
  Map<String, dynamic> toJson() => _$ApplicationModelToJson(this);
}