import 'dart:math';

import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/core/api_names.dart';
import 'package:test_us_app/data/data_sources/user_data/user_data_source.dart';
import 'package:test_us_app/data/models/user/user_model.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';

import '../../../core/net_driver.dart';
import '../../models/image/image_model.dart';

class UserDataSourceImpl implements UserDataSource {
  final logger = Logger();
  final NetDriver netDriver;

  UserDataSourceImpl(this.netDriver);

  @override
  Future<UserModel?> getUserByEmail(String email) async {
    final res = await netDriver.requestGetJson("", UserApi.getUserByEmail, param: email);
    if (res['status'] == 200) {
      return UserModel.fromJson(res['user']);
    } else {
      return null;
    }
  }

  @override
  Future<UserModel?> getUserById(String token, String id) async {
    final res = await netDriver.requestGetJson("", UserApi.getUserById, param: id);
    if (res['status'] == 200) {
      return UserModel.fromJson(res['user']);
    } else {
      return null;
    }
  }

  @override
  Future<UserModel?> getUserByNickname(String nickname) async {
    final res = await netDriver.requestGetJson("", UserApi.getUserByNickname, param: nickname);
    if (res['status'] == 200) {
      return UserModel.fromJson(res['data']);
    } else {
      return null;
    }
  }

  @override
  Future<bool> isEmailAvailable(String email) async {
    final res = await netDriver.requestGetJson("", UserApi.isEmailAvailable, param: email);
    if (res['status'] == 200) {
      return true;
    } else if (res['status'] == 404) {
      return false;
    } else {
      throw Exception('Server 500 Error');
    }
  }

  @override
  Future<bool> isNicknameAvailable(String nickname) async {
    final res = await netDriver.requestGetJson("", UserApi.isNicknameAvailable, param: nickname);
    if (res['status'] == 200) {
      return res['available'];
    } else if (res['status'] == 409) {
      return res['available'];
    } else {
      throw Exception('Server 500 Error');
    }
  }

  @override
  Future<bool> isPasswordValid(String password) async {
    final res = await netDriver.requestGetJson("", UserApi.isPasswordValid, param: password);
    if (res['status'] == 200) {
      return true;
    } else if (res['status'] == 404) {
      return false;
    } else {
      throw Exception('Server 500 Error');
    }
  }

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await netDriver.requestPostJson("", AuthApi.login, {"email": email, "password": password});
    if (res['status'] == 200) {
      return {'user': UserModel.fromJson(res['user']), 'token': res['token']};
    } else if (res['error'] != null) {
      String message = '';
      if (res['error'] == 'User not found') {
        message = '이메일을 찾을 수 없습니다.';
      } else {
        message = '비밀번호가 일치 하지 않습니다.';
      }
      return {'user': UserModel(), 'message': message};
    } else {
      throw Exception('Server 500 Error');
    }
  }

  @override
  Future<int> signup(UserModel userInfo) async {
    final res = await netDriver.requestPostJson("", AuthApi.signup, userInfo.toJson());
    logger.i('회원가입 결과: $res');
    if (res['status'] == 200) {
      return res['status'];
    } else {
      return res['status'];
    }
  }

  @override
  Future<bool> updatePassword(String newPassword) async {
    final res = await netDriver.requestPutJson("", UserApi.updatePassword, {"newPassword": newPassword});
    if (res['status'] == 200) {
      return true;
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<List<UserModel>> getUsersByIds(String token, List<String> ids) async {
    try {
      final res = await netDriver.requestPostJson(token, UserApi.getUsersByIds, {'ids': ids});
      if (res['status'] == 200) {
        final users = res['users'].map<UserModel>((e) => UserModel.fromJson(e)).toList();
        return users;
      } else {
        throw Exception('Error');
      }
    } on Exception catch (e) {
      // TODO
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<UserModel> updateUserInfo(String token, UserModel userInfo) async {
    final res = await netDriver.requestPostJson(token, UserApi.update, userInfo.toJson());
    if (res['status'] == 200) {
      return UserModel.fromJson(res['user']);
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<UserModel> updateUserInfoWithImage(String token, UserModel userInfo, XFile image,
      {ImageModel? oldImage}) async {
    Map<String, dynamic> res = {};
    if (oldImage != null) {
      final data = {'newImage': image, 'oldImage': oldImage};
      res = await netDriver.updateProfileFormData(token, UserApi.updateUserInfoWithImg, userInfo.toJson(), data);
    } else {
      final data = {'newImage': image};
      res = await netDriver.updateProfileFormData(token, UserApi.updateUserInfoWithImg, userInfo.toJson(), data);
    }
    if (res['status'] == 200) {
      return UserModel.fromJson(res['user']);
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<Map<String, dynamic>> authLogin(String email, AuthType authType) async {
    final res = await netDriver.requestPostJson("", AuthApi.authLogin, {"email": email});
    if (res['status'] == 200) {
      return {'user': UserModel.fromJson(res['user']), 'token': res['token']};
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<Map<String, dynamic>> authSignup(UserModel userInfo) async {
    final res = await netDriver.requestPostJson("", AuthApi.authSignup, userInfo.toJson());
    if (res['status'] == 200) {
      return {'user': UserModel.fromJson(res['user']), 'token': res['token']};
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<void> createFirebaseToken(String token, String messagingToken, String userId, String deviceType) async {
    final res = await netDriver.requestPostJson(
        token, FirebaseApi.createToken, {"userId": userId, 'fcmToken': messagingToken, "deviceType": deviceType});
    if (res['status'] == 200) {
      return;
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<void> updateFirebaseToken(String token, String messagingToken, String userId, String deviceType) async {
    final res = await netDriver.requestPostJson(
        token, FirebaseApi.updateToken, {"userId": userId, 'fcmToken': messagingToken, "deviceType": deviceType});
    if (res['status'] == 200) {
      return;
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<void> deleteFirebaseToken(String token, String messagingToken, String userId) async {
    try {
      final res =
          await netDriver.requestPostJson(token, FirebaseApi.deleteToken, {"userId": userId, 'fcmToken': messagingToken});
      if (res['status'] == 200) {
        return;
      } else {
        throw Exception('Error');
      }
    } on Exception catch (e) {
      // TODO
      logger.e(e.toString());
    }
  }
}
