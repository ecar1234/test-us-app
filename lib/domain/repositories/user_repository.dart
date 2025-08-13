

import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<Map<String,dynamic>> login(String email, String password);

  Future<int> signup(UserEntity userInfo);

  Future<UserEntity> getUserByEmail(String email);

  Future<UserEntity> getUserByNickname(String nickname);

  Future<UserEntity> getUserById(String id);

  Future<bool> isNicknameAvailable(String nickname);

  Future<bool> isEmailAvailable(String email);

  Future<bool> isPasswordValid(String password);

  Future<bool> updatePassword(String newPassword);
}