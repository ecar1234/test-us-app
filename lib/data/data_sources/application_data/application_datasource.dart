

import '../../models/application/application_model.dart';
import '../../models/post/recruit_post_model.dart';

abstract class ApplicationDataSource {
  Future<ApplicationModel> requestApply(String token, ApplicationModel application);
  Future<ApplicationModel> applyCancel(String token, int appId);
  Future<ApplicationModel> updateApplication(String token, ApplicationModel application);
  Future<ApplicationModel> applicationReject(String token, String userId, String postId);
  Future<ApplicationModel> completeApplications(String token, String userId, String postId);
  Future<List<ApplicationModel>> getUserApplication(String token, String userId);
  Future<List<ApplicationModel>> getRecruitApplications(String token, List<int> applicationIds);
}