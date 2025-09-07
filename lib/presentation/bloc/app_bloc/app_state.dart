import 'package:test_us_app/domain/entities/post_entity.dart';

enum UserAppState {
  startServiceState,
  userApplicationLoadCompletedState,
  requestState,
  loadingState,
  requestCompletedState,
  errorState
}

class AppState {
  UserAppState state;
  PostEntity? newPost;
  AppState({this.state = UserAppState.startServiceState, this.newPost});
}