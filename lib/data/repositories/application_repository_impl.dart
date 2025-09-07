

import 'package:test_us_app/data/models/application/application_model.dart';
import 'package:test_us_app/domain/entities/post_entity.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';
import 'package:test_us_app/domain/repositories/application_repo.dart';

import '../../domain/entities/application_entity.dart';
import '../data_sources/application_data/application_datasource.dart';

class ApplicationRepositoryImpl implements ApplicationRepository {
  final ApplicationDataSource remote;
  ApplicationRepositoryImpl(this.remote);

  @override
  Future<PostEntity> applicationReject(String token, ApplicationEntity application) async {
    // TODO: implement applicationReject
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> applyCancel(String token, int appId) async {
    final res = await remote.applyCancel(token, appId);
    return {'application': ApplicationEntity.toEntity(res['application']),
      'post': PostEntity.toPostEntity(res['post'])};
  }

  @override
  Future<PostEntity> completeApplications(String token, ApplicationEntity application) async {
    // TODO: implement completeApplications
    throw UnimplementedError();
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