

import 'package:test_us_app/domain/entities/promotion_post_entity.dart';
import 'package:test_us_app/domain/entities/recruit_post_entity.dart';

enum RecruitPostLoadState {
  serviceStartState,
  beforeDataLoadState,
  dataLoadState,
  userDataLoadState,
  postCreateCompletedState,
  recruitPostsLoadCompletedState,
  postUpdateCompletedState,
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

// class InitPostsLoadCompletedState extends RecruitPostState {
//   List<RecruitPostEntity> recruitPosts;
//   List<PromotionPostEntity> promotionPosts;
//   List<dynamic> favoritePosts;
//   InitPostsLoadCompletedState(this.recruitPosts, this.promotionPosts, this.favoritePosts);
// }
