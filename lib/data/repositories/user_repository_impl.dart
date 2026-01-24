import 'package:image_picker/image_picker.dart';
import 'package:test_us_app/data/models/user/user_model.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';

import '../../domain/entities/image_entity.dart';
import '../../domain/entities/recruit_post_entity.dart';
import '../../domain/entities/user_review_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../data_sources/user_data/user_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource remote;

  UserRepositoryImpl(this.remote);

  @override
  Future<UserEntity?> getUserByEmail(String email) async {
    final res = await remote.getUserByEmail(email);
    if (res == null) return null;
    return UserEntity.toEntity(res);
  }

  @override
  Future<UserEntity?> getUserById(String token, String id) async {
    final res = await remote.getUserById(token, id);
    if (res == null) return null;

    return UserEntity.toEntity(res);
  }

  @override
  Future<UserEntity?> getUserByNickname(String nickname) async {
    final res = await remote.getUserByNickname(nickname);
    if (res == null) return null;
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
  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await remote.login(email, password);
    if (res['message'] != null) {
      return {'user': UserEntity.toEntity(res['user']), 'message': res['message']};
    }
    return {'user': UserEntity.toEntity(res['user']), 'token': res['token']};
  }

  @override
  Future<int> signup(UserEntity userInfo) async {
    final userModel = UserEntity.toModel(userInfo);
    final res = await remote.signup(userModel);
    return res;
  }

  @override
  Future<bool> updatePassword(String newPassword) async {
    return await remote.updatePassword(newPassword);
  }

  @override
  Future<List<UserEntity>> getUsersByIds(String token, List<String> ids) async {
    final res = await remote.getUsersByIds(token, ids);
    if (res.isEmpty) return [];
    final users = res.map((e) => UserEntity.toEntity(e)).toList();

    return users;
  }

  @override
  Future<UserEntity> updateUserInfo(String token, UserEntity userInfo) async {
    final res = await remote.updateUserInfo(token, UserEntity.toModel(userInfo));
    return UserEntity.toEntity(res);
  }

  @override
  Future<UserEntity> updateUserInfoWithImage(String token, UserEntity userInfo, XFile image,
      {ImageEntity? oldImage}) async {
    UserModel res = UserModel();
    if (oldImage != null) {
      res = await remote.updateUserInfoWithImage(token, UserEntity.toModel(userInfo), image,
          oldImage: ImageEntity.toImageModel(oldImage));
    } else {
      res = await remote.updateUserInfoWithImage(token, UserEntity.toModel(userInfo), image);
    }
    return UserEntity.toEntity(res);
  }

  @override
  Future<Map<String, dynamic>> authLogin(String email, AuthType authType) async {
    final res = await remote.authLogin(email, authType);
    final user = UserEntity.toEntity(res['user']);
    final token = res['token'];
    return {'user': user, 'token': token};
  }

  @override
  Future<Map<String, dynamic>> authSignup(UserEntity userInfo) async {
    final userModel = UserEntity.toModel(userInfo);
    final res = await remote.authSignup(userModel);
    final user = UserEntity.toEntity(res['user']);
    final token = res['token'];
    return {'user': user, 'token': token};
  }

  @override
  Future<void> createFirebaseToken(String token, String messagingToken, String userId, String deviceType) async {
    await remote.createFirebaseToken(token, messagingToken, userId, deviceType);
  }

  @override
  Future<void> deleteFirebaseToken(String token, String messagingToken, String userId) async {
    await remote.deleteFirebaseToken(token, messagingToken ,userId);
  }

  @override
  Future<void> updateFirebaseToken(String token, String messagingToken, String userId, String deviceType) async {
    await remote.updateFirebaseToken(token, messagingToken, userId, deviceType);
  }

  @override
  Future<String> autoLogin(String token) async {
    final res = await remote.autoLogin(token);
    return res;
  }
}
