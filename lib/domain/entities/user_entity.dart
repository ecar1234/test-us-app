

import '../../data/models/user/user_model.dart';

class UserEntity {
  String? id;
  String? email;
  String? password;
  String? nickname;
  UserType? userType;
  UserRole? role;
  String? userName;
  DateTime? birth;
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
    this.createdAt,
    this.updatedAt,
  });

  static UserEntity toEntity(UserModel model) {
    return UserEntity(
        id: model.userId,
        email: model.email,
        password: model.password,
        nickname: model.nickname,
        userType: model.userType,
        role: model.role,
        userName: model.userName,
        birth: model.birth,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt
    );
  }

  static UserModel toModel(UserEntity entity) {
    return UserModel(
      userId: entity.id,
      email: entity.email,
      password: entity.password,
      nickname: entity.nickname,
      userType: entity.userType,
      role: entity.role,
      userName: entity.userName,
      birth: entity.birth,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt
    );
  }
}