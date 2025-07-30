

import '../../data/models/user/user_model.dart';

class UserEntity {
  String? userId;
  String? email;
  String? nickName;
  UserType? userType;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserEntity({
    this.userId,
    this.email,
    this.nickName,
    this.userType,
    this.createdAt,
    this.updatedAt,
  });
}