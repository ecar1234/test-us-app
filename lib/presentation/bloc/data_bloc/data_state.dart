

import 'package:test_us_app/domain/entities/post_entity.dart';

enum DataLoadState {
  serviceStartState,
  beforeDataLoadState,
  dataLoadState,
  userDataLoadState,
  initDataLoadCompletedState,
  postCreateCompletedState,
  postDataLoadCompletedState,
  postUpdateCompletedState,
  postDeleteCompletedState,
  getPostByIdCompletedState,
  errorState,
}

class DataState {
  DataLoadState state;
  PostEntity? post;
  DataState({this.state = DataLoadState.serviceStartState, this.post});
}
