
import 'package:image_picker/image_picker.dart';
import 'package:test_us_app/data/models/user/user_model.dart';
import 'package:test_us_app/domain/entities/image_entity.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';

import '../../data/sharedPreferences/auth_preference.dart';
import '../entities/user_review_entity.dart';
import '../repositories/user_repository.dart';

class UserUseCase {
  final UserRepository repository;
  UserUseCase(this.repository);
  final pref = AuthPreference.instance;
  Future<Map<String,dynamic>> login(String email, String password) async {
    final res = await repository.login(email, password);
    if(res['user'].id == null){
      return {'message':res['message']};
    }
    return res;
  }
  Future<int> signup(UserEntity userInfo) async {
    final res = await repository.signup(userInfo);
    return res;
  }

  Future<UserEntity?> getUserByEmail(String email) async {
    final res = await repository.getUserByEmail(email);
    return res;
  }

  Future<UserEntity?> getUserByNickname(String nickname) async {
    final res = await repository.getUserByNickname(nickname);
    return res;
  }

  Future<UserEntity?> getUserById(String token, String id) async {
    final res = await repository.getUserById(token, id);
    return res;
  }
  Future<List<UserEntity>> getUsersByIds(String token, List<String> ids) async {
    final res = await repository.getUsersByIds(token, ids);
    return res;
  }

  Future<bool> isNicknameAvailable(String nickname) async {
    final res = await repository.isNicknameAvailable(nickname);
    return res;
  }

  Future<bool> isEmailAvailable(String email) async {
    final res = await repository.isEmailAvailable(email);
    return res;
  }

  Future<bool> isPasswordValid(String password) async {
    final res = await repository.isPasswordValid(password);
    return res;
  }

  Future<bool> updatePassword(String newPassword) async {
    final res = await repository.updatePassword(newPassword);
    return res;
  }

  Future<UserEntity> updateUserInfo(String token, UserEntity userInfo) async {
    final res = await repository.updateUserInfo(token, userInfo);
    return res;
  }
  Future<UserEntity> updateUserInfoWithImage(String token, UserEntity userInfo, XFile image, {ImageEntity? oldImage}) async {
    UserEntity res;
    if(oldImage != null){
      res = await repository.updateUserInfoWithImage(token, userInfo, image, oldImage: oldImage);
    }else {
      res = await repository.updateUserInfoWithImage(token, userInfo, image);
    }
    return res;
  }

  Future<Map<String, dynamic>> authLogin(String email, AuthType authType) async {
    final res = await repository.authLogin(email, authType);
    return res;
  }

  Future<Map<String, dynamic>> authSignup(UserEntity user) async {
    final res = await repository.authSignup(user);
    return res;
  }
}