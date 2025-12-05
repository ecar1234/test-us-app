import 'package:test_us_app/domain/entities/recruit_post_entity.dart';

import '../../../domain/entities/application_entity.dart';

enum UserAppState {
  startServiceState,
  applicationsInitState,
  applicationCompletedState,
  applicationUpdateCompletedState,
  applicationCancelCompletedState,
  applicationRejectCompletedState,
  getUserApplicationsCompletedState,
  loadingState,
  requestCompletedState,
  errorState
}

class AppState {
  UserAppState state;
  RecruitPostEntity? newPost;
  ApplicationEntity? application;
  List<ApplicationEntity>? applications;

  AppState({this.state = UserAppState.startServiceState, this.newPost, this.application, this.applications});
}