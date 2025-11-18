import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/domain/entities/promotion_post_entity.dart';
import 'package:test_us_app/domain/entities/recruit_post_entity.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';

import '../../data/sharedPreferences/auth_preference.dart';
import '../../domain/use_cases/user_usecase.dart';

class UserProvider with ChangeNotifier {
  final UserUseCase useCase;
  final logger = Logger();
  final pref = AuthPreference.instance;
  UserProvider(this.useCase);

  UserEntity? _user;
  String? _token;
  bool? _isLogged;

  String? get token => _token;

  UserEntity? get user => _user;

  bool? get isLogged => _isLogged;




  Future<void> autoLogin(String token, UserEntity user) async {
    if (token.isEmpty || token == "") {
      _token = null;
      _user = null;
      _isLogged = false;
      notifyListeners();
      return;
    }
    _token = token;
    _user = user;
    _isLogged = true;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    try {
      final res = await useCase.login(email, password);

      _user = res['user'] as UserEntity;
      _token = res['token'] as String;
      _isLogged = true;
    } on Exception catch (e) {
      // TODO
      logger.e(e);
    }

    notifyListeners();
  }

  void updateUserInfo (UserEntity user) async {
    _user = user;
    await pref.setUserInfo(user);
    notifyListeners();
  }


  Future<int> signup(UserEntity userInfo) async {
    return await useCase.signup(userInfo);
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    _isLogged = false;
    notifyListeners();
  }

  Future<void> getUserByEmail(String email) async {
    _user = await useCase.getUserByEmail(email);
    notifyListeners();
  }

  Future<void> getUserByNickname(String nickname) async {
    _user = await useCase.getUserByNickname(nickname);
    notifyListeners();
  }

  Future<UserEntity?> getUserById(String token, String id) async {
    final res = await useCase.getUserById(token, id);
    _user = res;
    notifyListeners();
    return res;
  }

  // Future<List<UserEntity>> getUsersByIds(String token, List<String> ids) async {
  //   final res = await useCase.getUsersByIds(token, ids);
  //   return res;
  // }

  Future<bool> isNicknameAvailable(String nickname) async {
    return await useCase.isNicknameAvailable(nickname);
  }

  Future<bool> isEmailAvailable(String email) async {
    return await useCase.isEmailAvailable(email);
  }

  Future<bool> isPasswordValid(String password) async {
    return await useCase.isPasswordValid(password);
  }

  Future<bool> updatePassword(String newPassword) async {
    return await useCase.updatePassword(newPassword);
  }
}
