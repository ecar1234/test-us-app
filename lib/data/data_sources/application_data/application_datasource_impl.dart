

import 'dart:async';

import 'package:test_us_app/core/api_names.dart';
import 'package:test_us_app/core/net_driver.dart';
import 'package:test_us_app/data/models/application/application_model.dart';
import 'package:test_us_app/data/models/post/recruit_post_model.dart';

import 'application_datasource.dart';

class ApplicationDataSourceImpl implements ApplicationDataSource {
  final NetDriver netDriver;
  ApplicationDataSourceImpl(this.netDriver);

  @override
  Future<RecruitPostModel> applicationReject(String token, String userId, String postId) async {
    final res = await netDriver.requestPutJson(token, ApplicationApi.rejectUser, {'userId': userId, 'postId': postId});
    if(res['status'] == 200){
      final post = RecruitPostModel.fromJson(res['updatePost']);
      return post;
    }else {
      throw Exception('Error');
    }
  }

  @override
  Future<Map<String, dynamic>> applyCancel(String token, int appId) async {
    final res = await netDriver.requestPutJson(token, ApplicationApi.cancel, {'applicationId': appId.toString()});
    if(res['status'] == 200){
      final application = ApplicationModel.fromJson(res['application']);
      final post = RecruitPostModel.fromJson(res['post']);
      return {'application': application, 'post': post};
    }else {
      throw Exception('Error');
    }
  }

  @override
  Future<RecruitPostModel> completeApplications(String token, String userId, String postId) async {
    final res = await netDriver.requestPutJson(token, ApplicationApi.acceptUser, {'userId': userId, 'postId': postId});
    if(res['status'] == 200){
      final post = RecruitPostModel.fromJson(res['updatePost']);
      return post;
    }else {
      throw Exception('Error');
    }
  }

  @override
  Future<List<ApplicationModel>> getUserApplication(String token, String userId) async {
    final res = await netDriver.requestGetJson(token, ApplicationApi.findByUserId, param: userId);
    if(res['status'] == 202){
      // return (res['applications'] as List).map<ApplicationModel>((e) => ApplicationModel.fromJson(e)).toList();
      final applications = _startPolling(res['jobId'], token);
      return applications;
    }else {
      throw Exception('Error');
    }
  }

  @override
  Future<Map<String, dynamic>> requestApply(String token, ApplicationModel application) async {
    final res = await netDriver.requestPostJson(token, ApplicationApi.application, application.toJson());
    if(res['status'] == 200){
      final applicationData = ApplicationModel.fromJson(res['application']);
      final post = RecruitPostModel.fromJson(res['post']);
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
      final post = RecruitPostModel.fromJson(res['post']);
      return {'application': applicationData, 'post': post};
    }else {
      throw Exception('Error');
    }
  }

  Future<List<ApplicationModel>> _startPolling(String jobId, String token){
    final controller = Completer<List<ApplicationModel>>();
    Timer.periodic(Duration(seconds: 1), (timer) async {
      final res = await netDriver.requestGetJson(token, JobApi.jobGetApplications, param: jobId);
      if(res['status'] == 200) {
        final applications = (res['applications'] as List).map<ApplicationModel>((e) => ApplicationModel.fromJson(e)).toList();
        controller.complete(applications);
        timer.cancel();
      }});
    return controller.future;
  }
}