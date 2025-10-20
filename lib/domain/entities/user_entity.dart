

import '../../data/models/user/user_model.dart';
import 'application_entity.dart';

class UserEntity {
  String? id;
  String? email;
  String? password;
  String? nickname;
  UserType? userType;
  UserRole? role;
  String? userName;
  DateTime? birth;
  List<ApplicationEntity>? applications;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserEntity({
    this.id,
    this.email,
    this.password,
    this.nickname,
    this.userType,
    this.role,
    this.userName,
    this.birth,
    this.applications,
    this.createdAt,
    this.updatedAt,
  });

  static UserEntity toEntity(UserModel model) {
    final applications = model.applications?.map((e) => ApplicationEntity.toEntity(e)).toList();
    return UserEntity(
        id: model.userId,
        email: model.email,
        password: model.password,
        nickname: model.nickname,
        userType: model.userType,
        role: model.role,
        userName: model.userName,
        birth: model.birth,
        applications: applications,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt
    );
  }

  static UserModel toModel(UserEntity entity) {
    final applications = entity.applications?.map((e) => ApplicationEntity.toModel(e)).toList();
    return UserModel(
      userId: entity.id,
      email: entity.email,
      password: entity.password,
      nickname: entity.nickname,
      userType: entity.userType,
      role: entity.role,
      userName: entity.userName,
      birth: entity.birth,
      applications: applications,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt
    );
  }
}