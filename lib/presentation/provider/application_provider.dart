
import 'package:flutter/material.dart';
import 'package:test_us_app/domain/entities/application_entity.dart';
import 'package:test_us_app/domain/entities/recruit_post_entity.dart';

import '../../domain/use_cases/application_usecase.dart';

class ApplicationProvider with ChangeNotifier{
  final ApplicationUseCase useCase;
  ApplicationProvider(this.useCase);

  List<ApplicationEntity>? _applications;
  List<ApplicationEntity>? get applications => _applications;

  void requestApply(ApplicationEntity app)  {
    // final res = await useCase.requestApply(token, app);
    if(_applications == null){
      _applications = [app];
    }else {
      _applications!.add(app);
    }
    notifyListeners();
  }
  void cancelApplication(ApplicationEntity app)  {
    if(_applications!.any((element) => element.id == app.id)){
      final idx = _applications!.indexWhere((e) {
        return e.id == app.id;
      });
      _applications![idx] = app;
    }
    notifyListeners();
  }

  void requestUpdateApplication(ApplicationEntity app) {
    if(_applications!.any((element) => element.id == app.id)){
      final idx = _applications!.indexWhere((e) {
        return e.id == app.id;
      });
      _applications![idx] = app;
    }
    notifyListeners();
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