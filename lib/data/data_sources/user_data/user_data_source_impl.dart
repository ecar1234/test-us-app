import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/core/api_names.dart';
import 'package:test_us_app/data/data_sources/user_data/user_data_source.dart';
import 'package:test_us_app/data/models/user/user_model.dart';

import '../../../core/net_driver.dart';

class UserDataSourceImpl implements UserDataSource {
  final logger = Logger();
  final NetDriver netDriver;

  UserDataSourceImpl(this.netDriver);

  @override
  Future<UserModel> getUserByEmail(String email) async {
    final res =
        await netDriver.requestGetJson("", UserApi.getUserByEmail, parma: email);
    if (res['status'] == 200) {
      return UserModel.fromJson(res['data']);
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<UserModel> getUserById(String id) async {
    final res = await netDriver.requestGetJson("", UserApi.getUserById, parma:id);
    if (res['status'] == 200) {
      return UserModel.fromJson(res['data']);
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<UserModel> getUserByNickname(String nickname) async {
    final res =
        await netDriver.requestGetJson("", UserApi.getUserByNickname, parma:nickname);
    if (res['status'] == 200) {
      return UserModel.fromJson(res['data']);
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<bool> isEmailAvailable(String email) async {
    final res =
        await netDriver.requestGetJson("", UserApi.isEmailAvailable, parma:email);
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
    final res = await netDriver.requestGetJson(
        "", UserApi.isNicknameAvailable, parma:nickname);
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
    final res =
        await netDriver.requestGetJson("", UserApi.isPasswordValid, parma:password);
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
    final res = await netDriver.requestPostJson(
        "", AuthApi.login, {"email": email, "password": password});
    if (res['status'] == 200) {
      return {'user': UserModel.fromJson(res['user']), 'token': res['token']};
    } else {
      // debugPrint("$res, ${res['message']}");
      return {'user': UserModel()};
    }
  }

  @override
  Future<int> signup(UserModel userInfo) async {
    // logger.i('회원가입 시도: ${{
    //   "email": userInfo.email,
    //   "password": userInfo.password,
    //   "nickname": userInfo.nickname,
    //   "userType": userInfo.userType,
    //   "role": userInfo.role
    // }}');
    final res =
        await netDriver.requestPostJson("", AuthApi.signup, userInfo.toJson());
    logger.i('회원가입 결과: $res');
    if (res['status'] == 200) {
      return res['status'];
    } else {
      return res['status'];
    }
  }

  @override
  Future<bool> updatePassword(String newPassword) async {
    final res = await netDriver.requestPutJson(
        "", UserApi.updatePassword, {"newPassword": newPassword});
    if (res['status'] == 200) {
      return true;
    } else {
      throw Exception('Error');
    }
  }
}
