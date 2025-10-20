

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
  getUserRecruitmentPostsCompletedState,
  postImgRegisterCompletedState,
  postImgUpdateCompletedState,
  postImgDeleteCompletedState,
  errorState,
}

class DataState {
  DataLoadState state;
  PostEntity? post;
  List<PostEntity>? posts;
  List<Map<String, dynamic>>? images;

  DataState({this.state = DataLoadState.serviceStartState, this.post, this.images, this.posts});
}
