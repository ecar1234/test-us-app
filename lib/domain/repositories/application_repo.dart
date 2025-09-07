

import 'package:test_us_app/domain/entities/application_entity.dart';
import 'package:test_us_app/domain/entities/post_entity.dart';

abstract class ApplicationRepository {
  Future<Map<String, dynamic>> requestApply(String token, ApplicationEntity application);
  Future<Map<String, dynamic>> applyCancel(String token, int appId);
  Future<Map<String, dynamic>> updateApplication(String token, ApplicationEntity application);
  Future<PostEntity> applicationReject(String token, ApplicationEntity application);
  Future<PostEntity> completeApplications(String token, ApplicationEntity application);
  Future<List<ApplicationEntity>> getUserApplication(String token, String userId);
}