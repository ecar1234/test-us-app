
import 'package:test_us_app/domain/entities/promotion_post_entity.dart';

enum PromotionPostLoadState {
  serviceStartState,
  postLoadingState,
  postCreateCompletedState,
  postUpdateCompletedState,
  postDeleteCompletedState,
  getPaginationCompletedState,
  getPostByIdCompletedState,
  errorState,
  failedState
}

class PromotionPostState {
  PromotionPostLoadState state;
  // int? page;
  PromotionPostEntity? post;
  List<PromotionPostEntity>? posts;
  String? postId;
  PromotionPostState({ this.state = PromotionPostLoadState.serviceStartState, this.post, this.posts, this.postId }) ;
}

class PromotionPaginationState extends PromotionPostState {
  List<PromotionPostEntity> resPosts;
  int page;
  bool isLast;
  PromotionPaginationState({this.resPosts = const [], this.page = 0, this.isLast = false})
      : super(state: PromotionPostLoadState.getPaginationCompletedState);
}