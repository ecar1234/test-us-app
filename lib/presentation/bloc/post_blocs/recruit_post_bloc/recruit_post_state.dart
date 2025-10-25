

import 'package:test_us_app/domain/entities/recruit_post_entity.dart';

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
  errorState,
}

class RecruitPostState {
  RecruitPostLoadState state;
  RecruitPostEntity? post;
  List<RecruitPostEntity>? posts;
  List<Map<String, dynamic>>? images;

  RecruitPostState({this.state = RecruitPostLoadState.serviceStartState, this.post, this.images, this.posts});
}
