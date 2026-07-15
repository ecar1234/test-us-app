

import '../../../../domain/entities/promotion_post_entity.dart';
import '../../../../domain/entities/recruit_post_entity.dart';

enum BasePostLoadState {
  initialState,
  serviceStartState,
  dataLoadState,
  initPostDataLoadingState,
  getInitPostCompletedState,
  getUserInitPostsCompletedState,
  searchPostCompletedState,
  errorState,
  failedState
}

class BasePostState {
  BasePostLoadState state;
  List<RecruitPostEntity>? recruitPosts;
  List<PromotionPostEntity>? promotionPosts;
  List<dynamic>? favoritePosts;
  Map<String, dynamic>? initData;
  BasePostState(this.state , {this.recruitPosts , this.promotionPosts , this.favoritePosts, this.initData});
}

class GetSearchPostState extends BasePostState {
  List<RecruitPostEntity>? recruit;
  List<PromotionPostEntity>? promotion;

  GetSearchPostState(super.state, {this.recruit, this.promotion});
}