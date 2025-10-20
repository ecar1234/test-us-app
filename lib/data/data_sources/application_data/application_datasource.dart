

import '../../models/application/application_model.dart';
import '../../models/post/post_model.dart';

abstract class ApplicationDataSource {
  Future<Map<String, dynamic>> requestApply(String token, ApplicationModel application);
  Future<Map<String, dynamic>> applyCancel(String token, int appId);
  Future<Map<String, dynamic>> updateApplication(String token, ApplicationModel application);
  Future<PostModel> applicationReject(String token, String userId, String postId);
  Future<PostModel> completeApplications(String token, String userId, String postId);
  Future<List<ApplicationModel>> getUserApplication(String token, String userId);
}