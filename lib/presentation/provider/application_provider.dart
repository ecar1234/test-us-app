
import 'package:flutter/material.dart';
import 'package:test_us_app/domain/entities/application_entity.dart';
import 'package:test_us_app/domain/entities/post_entity.dart';

import '../../domain/use_cases/application_usecase.dart';

class ApplicationProvider with ChangeNotifier{
  final ApplicationUseCase useCase;
  ApplicationProvider(this.useCase);

  List<ApplicationEntity>? _applications;
  List<ApplicationEntity>? get applications => _applications;

  Future<PostEntity> requestApply(String token, ApplicationEntity app) async {
    final res = await useCase.requestApply(token, app);
    if(_applications == null){
      _applications = [res['application']];
    }else {
      _applications!.add(res['application']);
    }
    notifyListeners();
    return res['post'];
  }
  Future<PostEntity> cancelApplication(String token, int appId) async {
    final res = await useCase.cancelApply(token, appId);
    if(_applications!.any((element) => element.id == appId)){
      final idx = _applications!.indexWhere((e) {
        return e.id == res['application'].id;
      });
      _applications![idx] = res['application'];
    }
    notifyListeners();
    return res['post'];
  }

  Future<PostEntity> requestUpdateApplication(String token, ApplicationEntity app) async {
    final res = await useCase.updateApplication(token, app);
    if(_applications!.any((element) => element.id == app.id)){
      final idx = _applications!.indexWhere((e) {
        return e.id == res['application'].id;
      });
      _applications![idx] = res['application'];
    }
    notifyListeners();
    return res['post'];
  }

  Future<void> getMyApplications(String token, String userId) async {
    final res = await useCase.getMyApplications(token, userId);
    if(_applications == null){
      _applications = res;
    }else {
      _applications!.addAll(res);
    }
    notifyListeners();
  }

  Future<void> completeApplication(String token, String appId) async {}

  Future<void> rejectApplication(String token, String appId) async {}

}