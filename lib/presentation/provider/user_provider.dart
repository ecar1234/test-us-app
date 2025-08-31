
import 'package:flutter/material.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';

import '../../domain/use_cases/user_usecase.dart';

class UserProvider with ChangeNotifier {
  final UserUseCase useCase;
  UserProvider(this.useCase);

  UserEntity? _user;
  String? _token;

  String? get token => _token;
  UserEntity? get user => _user;

  Future<int> login(String email, String password) async {
    final res = await useCase.login(email, password);
    if(res['user'].id == null){
      return 401;
    }else {
      _user = res['user'] as UserEntity;
      _token = res['token'] as String;
    }
    notifyListeners();
    return 200;
  }

  Future<int> signup(UserEntity userInfo) async {
    return await useCase.signup(userInfo);
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
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

  Future<void> getUserById(String id) async {
    _user = await useCase.getUserById(id);
    notifyListeners();
  }


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