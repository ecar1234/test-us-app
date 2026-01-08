

import 'package:test_us_app/domain/entities/promotion_post_entity.dart';
import 'package:test_us_app/domain/entities/recruit_post_entity.dart';

import '../../../../data/models/package/recruit_post_applications_model.dart';

enum RecruitPostLoadState {
  serviceStartState,
  beforeDataLoadState,
  dataLoadState,
  userDataLoadState,
  postCreateCompletedState,
  recruitPostsLoadCompletedState,
  postUpdateCompletedState,
  postEndCompletedState,
  postDeleteCompletedState,
  getPostByIdCompletedState,
  getUserRecruitmentPostsCompletedState,
  getAppRecruitPostsCompletedState,
  postDataLoadCompletedState,
  errorState,
  failedState
}

class RecruitPostState {
  RecruitPostLoadState state;
  int page;
  RecruitPostEntity? post;
  List<RecruitPostEntity>? posts;
  List<Map<String, dynamic>>? images;

  RecruitPostState({this.state = RecruitPostLoadState.serviceStartState, this.page = 1, this.post, this.images, this.posts});
}

class GetPostApplicationsInfoState extends RecruitPostState {
  List<TResRecruitPostApplicationsInfo>? info;
  GetPostApplicationsInfoState({this.info});
}
