
import 'package:test_us_app/data/models/user/user_model.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';

import '../repositories/user_repository.dart';

class UserUseCase {
  final UserRepository repository;
  UserUseCase(this.repository);

  Future<UserEntity> login(String email, String password) async {
    final res = await repository.login(email, password);
    return res;
  }
  Future<bool> signup(UserEntity userInfo) async {
    final res = await repository.signup(userInfo);
    return res;
  }

  Future<UserEntity> getUserByEmail(String email) async {
    final res = await repository.getUserByEmail(email);
    return res;
  }

  Future<UserEntity> getUserByNickname(String nickname) async {
    final res = await repository.getUserByNickname(nickname);
    return res;
  }

  Future<UserEntity> getUserById(String id) async {
    final res = await repository.getUserById(id);
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

}