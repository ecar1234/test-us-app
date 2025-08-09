

import '../../models/user/user_model.dart';

abstract class UserDataSource {
  Future<UserModel> login(String email, String password);
  Future<bool> signup(UserModel userInfo);
  Future<UserModel> getUserByEmail(String email);
  Future<UserModel> getUserByNickname(String nickname);
  Future<UserModel> getUserById(String id);
  Future<bool> isNicknameAvailable(String nickname);
  Future<bool> isEmailAvailable(String email);
  Future<bool> isPasswordValid(String password);
  Future<bool> updatePassword(String newPassword);
}