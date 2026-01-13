

import 'dart:async';

import 'package:logger/logger.dart';
import 'package:test_us_app/core/api_names.dart';
import 'package:test_us_app/core/net_driver.dart';
import 'package:test_us_app/data/models/application/application_model.dart';
import 'package:test_us_app/data/models/post/recruit_post_model.dart';

import '../../models/package/recruit_post_tester_reviews_model.dart';
import 'application_datasource.dart';

class ApplicationDataSourceImpl implements ApplicationDataSource {
  final logger = Logger();
  final NetDriver netDriver;
  ApplicationDataSourceImpl(this.netDriver);

  @override
  Future<ApplicationModel> applicationReject(String token, String userId, String postId) async {
    final res = await netDriver.requestPutJson(token, ApplicationApi.rejectUser, {'userId': userId, 'postId': postId});
    if(res['status'] == 200){
      final application = ApplicationModel.fromJson(res['application']);
      return application;
    }else {
      throw Exception('Error');
    }
  }

  @override
  Future<Map<String, dynamic>> applyCancel(String token, int appId) async {
    final res = await netDriver.requestPutJson(token, ApplicationApi.cancel, {'applicationId': appId.toString()});
    if(res['status'] == 200){
      final applicationData = ApplicationModel.fromJson(res['application']);
      final post = RecruitPostModel.fromJson(res['newPost']);

      return {'application': applicationData, 'post': post};
    }else {
      throw Exception('Error');
    }
  }

  @override
  Future<ApplicationModel> completeApplications(String token, String userId, String postId) async {
    final res = await netDriver.requestPutJson(token, ApplicationApi.acceptUser, {'userId': userId, 'postId': postId});
    if(res['status'] == 200){
      final application = ApplicationModel.fromJson(res['application']);
      return application;
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
      final post = RecruitPostModel.fromJson(res['newPost']);

      return {'application': applicationData, 'post': post};
    }else {
      throw Exception('Error');
    }

  }

  @override
  Future<Map<String, dynamic>> updateApplication(String token, ApplicationModel application) async {
    try {
      final res = await netDriver.requestPutJson(token, ApplicationApi.update, application.toJson());
      if(res['status'] == 200){
        final applicationData = ApplicationModel.fromJson(res['application']);
        final post = RecruitPostModel.fromJson(res['newPost']);

        return {'application': applicationData, 'post': post};
      }else {
        throw Exception('Error');
      }
    } on Exception catch (e) {
      // TODO
      logger.e(e.toString());
      rethrow;
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

  @override
  Future<List<ApplicationModel>> getRecruitApplications(String token, List<int> applicationIds) async {
    final res = await netDriver.requestPostJson(token, ApplicationApi.getRecruitApplications, {'applicationIds': applicationIds});
    if(res['status'] == 200){
      final applications = (res['applications'] as List).map<ApplicationModel>((e) => ApplicationModel.fromJson(e)).toList();
      return applications;
    }else {
      throw Exception('Error');
    }
  }

  @override
  Future<List<RecruitPostTesterReviewsModel>> getTesterReviewsByAppIds(String token, List<int> applicationIds) async {
    final res = await netDriver.requestPostJson(token, ApplicationApi.getTesterReviewsByAppIds, {'appIds': applicationIds});
    if(res['status'] == 200){
      final info = (res['info'] as List).map<RecruitPostTesterReviewsModel>((e) => RecruitPostTesterReviewsModel.fromJson(e)).toList();
      return info;
    }else {
      throw Exception('Error');

    }
  }

}