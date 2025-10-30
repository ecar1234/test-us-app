
import 'package:test_us_app/domain/entities/promotion_post_entity.dart';

enum PromotionPostLoadState {
  serviceStartState,
  postLoadingState,
  postCreateCompletedState,
  postUpdateCompletedState,
  errorState,
  failedState
}

class PromotionPostState {
  PromotionPostLoadState state;
  PromotionPostEntity? post;
  List<PromotionPostEntity>? posts;
  PromotionPostState({ this.state = PromotionPostLoadState.serviceStartState, this.post, this.posts }) ;
}