

import 'package:test_us_app/domain/entities/promotion_post_entity.dart';
import 'package:test_us_app/domain/entities/recruit_post_entity.dart';

enum RecruitPostLoadState {
  serviceStartState,
  beforeDataLoadState,
  dataLoadState,
  userDataLoadState,
  postCreateCompletedState,
  postDataLoadCompletedState,
  postUpdateCompletedState,
  postDeleteCompletedState,
  getPostByIdCompletedState,
  getUserRecruitmentPostsCompletedState,
  errorState,
  failedState
}

class RecruitPostState {
  RecruitPostLoadState state;
  RecruitPostEntity? post;
  List<RecruitPostEntity>? posts;
  List<Map<String, dynamic>>? images;

  RecruitPostState({this.state = RecruitPostLoadState.serviceStartState, this.post, this.images, this.posts});
}

class InitPostsLoadCompletedState extends RecruitPostState {
  List<RecruitPostEntity> recruitPosts;
  List<PromotionPostEntity> promotionPosts;
  List<dynamic> favoritePosts;
  InitPostsLoadCompletedState(this.recruitPosts, this.promotionPosts, this.favoritePosts);
}
