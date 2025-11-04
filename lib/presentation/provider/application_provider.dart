
import 'package:flutter/material.dart';
import 'package:test_us_app/domain/entities/application_entity.dart';
import 'package:test_us_app/domain/entities/recruit_post_entity.dart';

import '../../domain/use_cases/application_usecase.dart';

class ApplicationProvider with ChangeNotifier{
  final ApplicationUseCase useCase;
  ApplicationProvider(this.useCase);

  List<ApplicationEntity>? _userApplications;
  List<RecruitPostEntity>? _userApplicationPosts;
  List<ApplicationEntity>? get userApplications => _userApplications;
  List<RecruitPostEntity>? get userApplicationPosts => _userApplicationPosts;


  Future<void> getMyApplications(String token, String userId) async {
    final res = await useCase.getMyApplications(token, userId);
    if(_userApplications == null){
      _userApplications = res;
    }else {
      _userApplications!.addAll(res);
    }
    notifyListeners();
  }

  void logout(){
    if(_userApplications != null && _userApplications!.isNotEmpty){
      _userApplications!.clear();
      _userApplications = [];
    }
    if(_userApplicationPosts != null && _userApplicationPosts!.isNotEmpty) {
      _userApplicationPosts!.clear();
      _userApplicationPosts = [];
    }
    notifyListeners();
  }

  void requestApply(ApplicationEntity app)  {
    // final res = await useCase.requestApply(token, app);
    if(_userApplications == null){
      _userApplications = [app];
    }else {
      _userApplications!.add(app);
    }
    notifyListeners();
  }
  void cancelApplication(ApplicationEntity app, RecruitPostEntity post)  {
    if(_userApplications!.any((element) => element.id == app.id)){
      _userApplications = _userApplications!.where((element) => element.id != app.id).toList();
    }
    if(_userApplicationPosts!.any((element) => element.id == post.id)){
      _userApplicationPosts = _userApplicationPosts!.where((element) => element.id != post.id).toList();
    }
    notifyListeners();
  }

  void requestUpdateApplication(ApplicationEntity app) {
    if(_userApplications!.any((element) => element.id == app.id)){
      final idx = _userApplications!.indexWhere((e) {
        return e.id == app.id;
      });
      _userApplications![idx] = app;
    }
    notifyListeners();
  }

  void setUserApplicationPosts(List<RecruitPostEntity> posts) {
    if(_userApplicationPosts == null || _userApplicationPosts!.isEmpty) {
      _userApplicationPosts = posts;
    }
    notifyListeners();
  }
  Future<void> completeApplication(String token, String appId) async {}

  Future<void> rejectApplication(String token, String appId) async {}

}