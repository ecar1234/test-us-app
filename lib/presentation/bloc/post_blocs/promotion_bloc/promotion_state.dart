
enum PromotionPostLoadState { serviceStartState }

class PromotionPostState {
  PromotionPostLoadState state;
  PromotionPostState({ this.state = PromotionPostLoadState.serviceStartState }) ;
}