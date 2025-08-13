

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_us_app/data/models/user/user_model.dart';

import '../../domain/entities/user_entity.dart';

class AuthPreference {
  AuthPreference._internal();
  static final AuthPreference _singleton = AuthPreference._internal();
  static AuthPreference get instance => _singleton;

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<void> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<void> setUserInfo(UserEntity userInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userModel = UserEntity.toModel(userInfo);
    final userInfoJson = userModel.toJson();
    final userString = jsonEncode(userInfoJson);
    await prefs.setString('userInfo', userString);
  }

  Future<UserEntity> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInfoJson = prefs.getString('userInfo');
    if (userInfoJson == null) {
      return UserEntity();
    }
    final userInfoMap = jsonDecode(userInfoJson);
    final userModel = UserModel.fromJson(userInfoMap);
    final userEntity = UserEntity.toEntity(userModel);
    return userEntity;
  }
  Future<void> removeUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userInfo');
  }
}