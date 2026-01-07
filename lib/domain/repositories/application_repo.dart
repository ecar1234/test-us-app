

import 'package:test_us_app/domain/entities/application_entity.dart';
import 'package:test_us_app/domain/entities/recruit_post_entity.dart';

abstract class ApplicationRepository {
  Future<Map<String, dynamic>> requestApply(String token, ApplicationEntity application);
  Future<Map<String, dynamic>> applyCancel(String token, int appId);
  Future<Map<String, dynamic>> updateApplication(String token, ApplicationEntity application);
  Future<ApplicationEntity> applicationReject(String token, String userId, String postId);
  Future<ApplicationEntity> completeApplications(String token, String userId, String postId);
  Future<List<ApplicationEntity>> getUserApplication(String token, String userId);
  Future<List<ApplicationEntity>> getRecruitApplications(String token, List<int> applicationIds);
}