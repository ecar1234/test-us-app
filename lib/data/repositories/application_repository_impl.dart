
import 'package:test_us_app/domain/entities/post_entity.dart';
import 'package:test_us_app/domain/repositories/application_repo.dart';

import '../../domain/entities/application_entity.dart';
import '../data_sources/application_data/application_datasource.dart';

class ApplicationRepositoryImpl implements ApplicationRepository {
  final ApplicationDataSource remote;
  ApplicationRepositoryImpl(this.remote);

  @override
  Future<PostEntity> applicationReject(String token, String userId, String postId) async {
    final res = await remote.applicationReject(token, userId, postId);
    return PostEntity.toPostEntity(res);
  }

  @override
  Future<Map<String, dynamic>> applyCancel(String token, int appId) async {
    final res = await remote.applyCancel(token, appId);
    return {'application': ApplicationEntity.toEntity(res['application']),
      'post': PostEntity.toPostEntity(res['post'])};
  }

  @override
  Future<PostEntity> completeApplications(String token, String userId, String postId) async {
    final res = await remote.completeApplications(token, userId, postId);
    return PostEntity.toPostEntity(res);
  }

  @override
  Future<List<ApplicationEntity>> getUserApplication(String token, String userId) async {
    final res = await remote.getUserApplication(token, userId);
    return res.map<ApplicationEntity>((e) => ApplicationEntity.toEntity(e)).toList();
  }

  @override
  Future<Map<String, dynamic>> requestApply(String token, ApplicationEntity application) async {
    final appData = ApplicationEntity.toModel(application);
    final res = await remote.requestApply(token, appData);
    return {'application': ApplicationEntity.toEntity(res['application']), 'post': PostEntity.toPostEntity(res['post'])};
  }

  @override
  Future<Map<String, dynamic>> updateApplication(String token, ApplicationEntity application) async {
    final appData = ApplicationEntity.toModel(application);
    final res = await remote.updateApplication(token, appData);
    return {'application': ApplicationEntity.toEntity(res['application']), 'post': PostEntity.toPostEntity(res['post'])};
  }

}