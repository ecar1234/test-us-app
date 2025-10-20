
import '../../../domain/entities/review_entity.dart';

enum ReviewDataState {
  serviceStartState,
  loadingState,
  getUserReviewCompletedState,
  getUserReviewAverageCompletedState,
  errorState }

class ReviewState {
  ReviewDataState state;
  ReviewEntity? review;
  List<ReviewEntity>? reviews;
  List<Map<String, dynamic>>? reviewAverages;
  ReviewState(this.state, {this.review, this.reviews, this.reviewAverages});
}