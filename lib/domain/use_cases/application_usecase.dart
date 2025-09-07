

import 'package:test_us_app/domain/entities/application_entity.dart';
import 'package:test_us_app/domain/entities/post_entity.dart';

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

  Future<PostEntity> completeApplication(String token, ApplicationEntity app) async {
    final res = await repository.completeApplications(token, app);
    return res;
  }

  Future<PostEntity> rejectApplication(String token, ApplicationEntity app) async {
    final res = await repository.applicationReject(token, app);
    return res;
  }

  Future<List<ApplicationEntity>> getMyApplications(String token, String userId) async {
    final res = await repository.getUserApplication(token, userId);
    return res;
  }

}