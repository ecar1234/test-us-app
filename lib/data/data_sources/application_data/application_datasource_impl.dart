

import 'package:test_us_app/core/api_names.dart';
import 'package:test_us_app/core/net_driver.dart';
import 'package:test_us_app/data/models/application/application_model.dart';
import 'package:test_us_app/data/models/post/post_model.dart';

import 'application_datasource.dart';

class ApplicationDataSourceImpl implements ApplicationDataSource {
  final NetDriver netDriver;
  ApplicationDataSourceImpl(this.netDriver);

  @override
  Future<PostModel> applicationReject(String token, ApplicationModel application) {
    // TODO: implement applicationReject
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> applyCancel(String token, int appId) async {
    final res = await netDriver.requestPutJson(token, ApplicationApi.cancel, {'applicationId': appId.toString()});
    if(res['status'] == 200){
      final application = ApplicationModel.fromJson(res['application']);
      final post = PostModel.fromJson(res['post']);
      return {'application': application, 'post': post};
    }else {
      throw Exception('Error');
    }
  }

  @override
  Future<PostModel> completeApplications(String token, ApplicationModel application) {
    // TODO: implement completeApplications
    throw UnimplementedError();
  }

  @override
  Future<List<ApplicationModel>> getUserApplication(String token, String userId) async {
    final res = await netDriver.requestGetJson(token, ApplicationApi.findByUserId, parma: userId);
    if(res['status'] == 200){
      return (res['applications'] as List).map<ApplicationModel>((e) => ApplicationModel.fromJson(e)).toList();
    }else {
      throw Exception('Error');
    }
  }

  @override
  Future<Map<String, dynamic>> requestApply(String token, ApplicationModel application) async {
    final res = await netDriver.requestPostJson(token, ApplicationApi.application, application.toJson());
    if(res['status'] == 200){
      final applicationData = ApplicationModel.fromJson(res['application']);
      final post = PostModel.fromJson(res['post']);
      return {'application': applicationData, 'post': post};
    }else {
      throw Exception('Error');
    }

  }

  @override
  Future<Map<String, dynamic>> updateApplication(String token, ApplicationModel application) async {
    final res = await netDriver.requestPutJson(token, ApplicationApi.update, application.toJson());
    if(res['status'] == 200){
      final applicationData = ApplicationModel.fromJson(res['application']);
      final post = PostModel.fromJson(res['post']);
      return {'application': applicationData, 'post': post};
    }else {
      throw Exception('Error');
    }
  }
}