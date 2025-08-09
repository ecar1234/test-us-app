

import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> login(String email, String password);

  Future<bool> signup(UserEntity userInfo);

  Future<UserEntity> getUserByEmail(String email);

  Future<UserEntity> getUserByNickname(String nickname);

  Future<UserEntity> getUserById(String id);

  Future<bool> isNicknameAvailable(String nickname);

  Future<bool> isEmailAvailable(String email);

  Future<bool> isPasswordValid(String password);

  Future<bool> updatePassword(String newPassword);
}