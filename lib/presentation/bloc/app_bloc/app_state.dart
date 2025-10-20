import 'package:test_us_app/domain/entities/post_entity.dart';

import '../../../domain/entities/application_entity.dart';

enum UserAppState {
  startServiceState,
  applicationsInitState,
  applicationCompletedState,
  applicationUpdateCompletedState,
  applicationCancelCompletedState,
  applicationRejectCompletedState,
  loadingState,
  requestCompletedState,
  errorState
}

class AppState {
  UserAppState state;
  PostEntity? newPost;
  ApplicationEntity? application;
  AppState({this.state = UserAppState.startServiceState, this.newPost, this.application});
}