

import 'package:test_us_app/domain/entities/application_entity.dart';
import 'package:test_us_app/domain/entities/recruit_post_entity.dart';

import '../repositories/application_repo.dart';

class ApplicationUseCase {
  final ApplicationRepository repository;
  ApplicationUseCase(this.repository);

  Future<Map<String, dynamic>> requestApply(String token, ApplicationEntity app) async {
    final res = await repository.requestApply(token, app);
    return res;
  }

  Future<Map<String, dynamic>> cancelApply(String token, int appId) async {
    final res = await repository.applyCancel(token, appId);
    return res;
  }

  Future<Map<String, dynamic>> updateApplication(String token, ApplicationEntity app) async {
    final res = await repository.updateApplication(token, app);
    return res;
  }

  Future<ApplicationEntity> completeApplication(String token, String userId, String postId) async {
    final res = await repository.completeApplications(token, userId, postId);
    return res;
  }

  Future<ApplicationEntity> rejectApplication(String token, String userId, String postId) async {
    final res = await repository.applicationReject(token, userId, postId);
    return res;
  }

  Future<List<ApplicationEntity>> getMyApplications(String token, String userId) async {
    final res = await repository.getUserApplication(token, userId);
    return res;
  }

  Future<List<ApplicationEntity>> getRecruitApplications(String token, List<int> applicationIds) async {
    final res = await repository.getRecruitApplications(token, applicationIds);
    return res;
  }


}