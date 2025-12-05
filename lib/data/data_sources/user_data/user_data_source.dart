

import 'package:image_picker/image_picker.dart';
import 'package:test_us_app/data/models/image/image_model.dart';

import '../../models/review/user_review_model.dart';
import '../../models/user/user_model.dart';

abstract class UserDataSource {
  Future<Map<String,dynamic>> login(String email, String password);
  Future<int> signup(UserModel userInfo);
  Future<UserModel?> getUserByEmail(String email);
  Future<UserModel?> getUserByNickname(String nickname);
  Future<UserModel?> getUserById(String token, String id);
  Future<bool> isNicknameAvailable(String nickname);
  Future<bool> isEmailAvailable(String email);
  Future<bool> isPasswordValid(String password);
  Future<bool> updatePassword(String newPassword);
  Future<List<UserModel>> getUsersByIds(String token, List<String> ids);
  Future<UserModel> updateUserInfo(String token, UserModel userInfo);
  Future<UserModel> updateUserInfoWithImage(String token, UserModel userInfo, XFile image, {ImageModel? oldImage});
  Future<Map<String, dynamic>> authLogin(String email, AuthType authType);
  Future<Map<String, dynamic>> authSignup(UserModel userInfo);
}