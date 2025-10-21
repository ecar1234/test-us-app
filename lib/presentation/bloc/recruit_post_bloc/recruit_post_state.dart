

import 'package:test_us_app/domain/entities/post_entity.dart';

enum RecruitPostLoadState {
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

class RecruitPostState {
  RecruitPostLoadState state;
  PostEntity? post;
  List<PostEntity>? posts;
  List<Map<String, dynamic>>? images;

  RecruitPostState({this.state = RecruitPostLoadState.serviceStartState, this.post, this.images, this.posts});
}
