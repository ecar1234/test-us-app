import '../../data/models/application/application_model.dart';

class ApplicationEntity {
  int? id;
  ApplicationPlatform? platform;
  MobileOsType? mobileOs;
  ApplicationStatus? status;
  DateTime? appliedAt;
  DateTime? updatedAt;
  String? postId;
  String? applicantId;

  ApplicationEntity({
    this.id,
    this.platform,
    this.mobileOs,
    this.status,
    this.appliedAt,
    this.updatedAt,
    this.postId,
    this.applicantId,
  });

  static ApplicationEntity toEntity(ApplicationModel model) {
    return ApplicationEntity(
      id: model.id,
      platform: model.platform,
      mobileOs: model.mobileOs,
      status: model.status,
      appliedAt: model.appliedAt,
      updatedAt: model.updatedAt,
      postId: model.postId,
      applicantId: model.applicantId,
    );
  }

  static ApplicationModel toModel(ApplicationEntity entity) {
    return ApplicationModel(
      id: entity.id,
      platform: entity.platform,
      mobileOs: entity.mobileOs,
      status: entity.status,
      appliedAt: entity.appliedAt,
      updatedAt: entity.updatedAt,
      postId: entity.postId,
      applicantId: entity.applicantId,
    );
  }
}
