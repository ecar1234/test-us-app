

import 'package:image_picker/image_picker.dart';
import 'package:test_us_app/data/models/user/user_model.dart';

import '../entities/image_entity.dart';
import '../entities/user_review_entity.dart';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<Map<String,dynamic>> login(String email, String password);
  Future<String> autoLogin(String token);
  Future<int> signup(UserEntity userInfo);
  Future<UserEntity?> getUserByEmail(String email);
  Future<UserEntity?> getUserByNickname(String nickname);
  Future<UserEntity?> getUserById(String token, String id);
  Future<List<UserEntity>> getUsersByIds(String token, List<String> ids);
  Future<bool> isNicknameAvailable(String nickname);
  Future<bool> isEmailAvailable(String email);
  Future<bool> isPasswordValid(String password);
  Future<bool> updatePassword(String newPassword);
  Future<UserEntity> updateUserInfoWithImage(String token, UserEntity userInfo, XFile image, {ImageEntity? oldImage});
  Future<UserEntity> updateUserInfo(String token, UserEntity userInfo);
  Future<Map<String, dynamic>> authLogin(String email, AuthType authType);
  Future<Map<String, dynamic>> authSignup(UserEntity userInfo);
  Future<void> createFirebaseToken(String token, String messagingToken, String userId, String deviceType);
  Future<void> updateFirebaseToken(String token, String messagingToken, String userId, String deviceType);
  Future<void> deleteFirebaseToken(String token, String messagingToken, String userId);
}