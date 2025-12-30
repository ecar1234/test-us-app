import 'package:test_us_app/domain/entities/user_entity.dart';

import '../../../domain/entities/post_review_entity.dart';
import '../../../domain/entities/user_review_entity.dart';

enum ReviewDataState {
  serviceStartState,
  loadingState,
  getUserReviewCompletedState,
  getPostReviewCompletedState,
  getTestersReviewCompletedState,
  getPostReviewByReviewIdCompletedState,
  getUserReviewByReviewIdCompletedState,
  createUserReviewCompletedState,
  createRecruitPostReviewCompletedState,
  createPromotionPostReviewCompletedState,
  errorState,
  failedState
}

class ReviewState {
  ReviewDataState state;

  ReviewState(this.state);
}

class GetUserReviewDataCompletedState extends ReviewState {
  final List<UserReviewEntity> reviews;
  final double averageRating;

  GetUserReviewDataCompletedState(this.reviews, this.averageRating)
      : super(ReviewDataState.getUserReviewCompletedState);
}

class GetPostReviewState extends ReviewState {
  final List<PostReviewEntity> reviews;
  final List<UserEntity> users;

  GetPostReviewState(this.reviews, this.users)
      : super(ReviewDataState.getPostReviewCompletedState);
}
class GetReviewByUserReviewIdCompletedState extends ReviewState {
  final UserReviewEntity review;

  GetReviewByUserReviewIdCompletedState(this.review): super(ReviewDataState.getUserReviewByReviewIdCompletedState);
}

class GetReviewByPostReviewIdCompletedState extends ReviewState {
  final PostReviewEntity review;
  GetReviewByPostReviewIdCompletedState(this.review): super(ReviewDataState.getPostReviewByReviewIdCompletedState);
}


class GetTestersReviewDataCompletedState extends ReviewState {
  final List<UserEntity> users;
  final List<UserReviewEntity> reviews;


  GetTestersReviewDataCompletedState({required this.users, required this.reviews})
      : super(ReviewDataState.getTestersReviewCompletedState);
}

class CreateUserReviewCompletedState extends ReviewState {
  final UserReviewEntity review;

  CreateUserReviewCompletedState(this.review) : super(ReviewDataState.createUserReviewCompletedState);
}

class CreateRecruitPostReviewCompletedState extends ReviewState {
  final PostReviewEntity review;

  CreateRecruitPostReviewCompletedState(this.review): super(ReviewDataState.createRecruitPostReviewCompletedState);
}

class CreatePromotionPostReviewCompletedState extends ReviewState {
  final PostReviewEntity review;

  CreatePromotionPostReviewCompletedState(this.review): super(ReviewDataState.createPromotionPostReviewCompletedState);
}

