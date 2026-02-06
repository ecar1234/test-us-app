

import 'package:test_us_app/domain/entities/image_entity.dart';

import '../../data/models/user/user_model.dart';
import 'application_entity.dart';

class UserEntity {
  String? id;
  String? email;
  String? password;
  String? nickname;
  ImageEntity? profileImg;
  UserStatus? status;
  UserType? userType;
  UserRole? role;
  String? userName;
  DateTime? birth;
  AuthType? method;
  List<int>? applications;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserEntity({
    this.id,
    this.email,
    this.password,
    this.nickname,
    this.profileImg,
    this.status,
    this.userType,
    this.role,
    this.userName,
    this.birth,
    this.method,
    this.applications,
    this.createdAt,
    this.updatedAt,
  });

  static UserEntity toEntity(UserModel model) {
    // final applications = model.applications?.map((e) => ApplicationEntity.toEntity(e)).toList();
    final profileImage = model.profileImg != null ? ImageEntity.toImageEntity(model.profileImg!) : null;
    return UserEntity(
        id: model.userId,
        email: model.email,
        password: model.password,
        nickname: model.nickname,
        profileImg: profileImage,
        status: model.status,
        userType: model.userType,
        role: model.role,
        userName: model.userName,
        birth: model.birth,
        method: model.method,
        applications: model.applications,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt
    );
  }

  static UserModel toModel(UserEntity entity) {
    // final applications = entity.applications?.map((e) => ApplicationEntity.toModel(e)).toList();
    final profileImage = entity.profileImg != null ? ImageEntity.toImageModel(entity.profileImg!) : null;
    return UserModel(
      userId: entity.id,
      email: entity.email,
      password: entity.password,
      nickname: entity.nickname,
      profileImg: profileImage,
      userType: entity.userType,
      role: entity.role,
      userName: entity.userName,
      birth: entity.birth,
      method: entity.method,
      applications: entity.applications,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt
    );
  }
}