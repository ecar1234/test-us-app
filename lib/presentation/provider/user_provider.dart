
import 'package:flutter/material.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';

import '../../domain/use_cases/user_usecase.dart';

class UserProvider with ChangeNotifier {
  final UserUseCase useCase;
  UserProvider(this.useCase);

  UserEntity? _user;
  UserEntity? get user => _user;

  Future<void> login(String email, String password) async {
    _user = await useCase.login(email, password);
    debugPrint("user: $_user");
    notifyListeners();
  }

  Future<bool> signup(UserEntity userInfo) async {
    return await useCase.signup(userInfo);
  }

  Future<void> logout() async {
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