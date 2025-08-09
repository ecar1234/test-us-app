

import 'package:test_us_app/data/models/user/user_model.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';

import '../../domain/repositories/user_repository.dart';
import '../data_sources/user_data/user_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource remote;

  UserRepositoryImpl(this.remote);

  @override
  Future<UserEntity> getUserByEmail(String email) async {
    final res = await remote.getUserByEmail(email);
    return UserEntity.toEntity(res);
  }

  @override
  Future<UserEntity> getUserById(String id) async {
    final res = await remote.getUserById(id);
    return UserEntity.toEntity(res);
  }

  @override
  Future<UserEntity> getUserByNickname(String nickname) async {
    final res = await remote.getUserByNickname(nickname);
    return UserEntity.toEntity(res);
  }

  @override
  Future<bool> isEmailAvailable(String email) async {
    return await remote.isEmailAvailable(email);
  }

  @override
  Future<bool> isNicknameAvailable(String nickname) async {
    return await remote.isNicknameAvailable(nickname);
  }

  @override
  Future<bool> isPasswordValid(String password) async {
    return await remote.isPasswordValid(password);
  }

  @override
  Future<UserEntity> login(String email, String password) async {
    final res = await remote.login(email, password);
    return UserEntity.toEntity(res);
  }

  @override
  Future<bool> signup(UserEntity userInfo) async {
    final userModel = UserEntity.toModel(userInfo);
    final res = await remote.signup(userModel);
    return res;
  }

  @override
  Future<bool> updatePassword(String newPassword) async {
    return await remote.updatePassword(newPassword);
  }


}