
import 'package:test_us_app/domain/entities/recruit_post_entity.dart';
import 'package:test_us_app/domain/repositories/application_repo.dart';

import '../../domain/entities/application_entity.dart';
import '../data_sources/application_data/application_datasource.dart';

class ApplicationRepositoryImpl implements ApplicationRepository {
  final ApplicationDataSource remote;
  ApplicationRepositoryImpl(this.remote);

  @override
  Future<ApplicationEntity> applicationReject(String token, String userId, String postId) async {
    final res = await remote.applicationReject(token, userId, postId);
    return ApplicationEntity.toEntity(res);
  }

  @override
  Future<ApplicationEntity> applyCancel(String token, int appId) async {
    final res = await remote.applyCancel(token, appId);
    return ApplicationEntity.toEntity(res);
  }

  @override
  Future<ApplicationEntity> completeApplications(String token, String userId, String postId) async {
    final res = await remote.completeApplications(token, userId, postId);
    return ApplicationEntity.toEntity(res);
  }

  @override
  Future<List<ApplicationEntity>> getUserApplication(String token, String userId) async {
    final res = await remote.getUserApplication(token, userId);
    return res.map<ApplicationEntity>((e) => ApplicationEntity.toEntity(e)).toList();
  }

  @override
  Future<ApplicationEntity> requestApply(String token, ApplicationEntity application) async {
    final appData = ApplicationEntity.toModel(application);
    final res = await remote.requestApply(token, appData);
    return ApplicationEntity.toEntity(res);
  }

  @override
  Future<ApplicationEntity> updateApplication(String token, ApplicationEntity application) async {
    final appData = ApplicationEntity.toModel(application);
    final res = await remote.updateApplication(token, appData);
    return ApplicationEntity.toEntity(res);
  }

  @override
  Future<List<ApplicationEntity>> getRecruitApplications(String token, List<int> applicationIds) async {
    final res = await remote.getRecruitApplications(token, applicationIds);
    return res.map<ApplicationEntity>((e) => ApplicationEntity.toEntity(e)).toList();
  }
}