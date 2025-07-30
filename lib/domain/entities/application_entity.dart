import '../../data/models/application/application_model.dart';

class ApplicationEntity {
  String? appId;
  ApplicationPlatform? platform;
  ApplicationStatus? status;
  DateTime? appliedAt;
  DateTime? updatedAt;
  String? postId;
  String? appUserId;

  ApplicationEntity({
    this.appId,
    this.platform,
    this.status,
    this.appliedAt,
    this.updatedAt,
    this.postId,
    this.appUserId,
  });
}
