import 'package:test_us_app/domain/entities/package/review_init_data_entity.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';

import '../../../domain/entities/post_review_entity.dart';
import '../../../domain/entities/user_review_entity.dart';

// enum ReviewDataState {
//   serviceStartState,
//   loadingState,
//   getUserReviewCompletedState,
//   getPostReviewCompletedState,
//   getTestersReviewCompletedState,
//   getPostReviewByReviewIdCompletedState,
//   getUserReviewByReviewIdCompletedState,
//   createUserReviewCompletedState,
//   createRecruitPostReviewCompletedState,
//   createPromotionPostReviewCompletedState,
//   errorState,
//   failedState
// }

class ReviewState {
  // ReviewDataState state;
  //
  // ReviewState(this.state);
}
class ReviewDataServiceStartState extends ReviewState {}
class ReviewDataLoadingState extends ReviewState {}
class ReviewDataErrorState extends ReviewState {}
class ReviewDataFailedState extends ReviewState {}

class GetUserReviewDataCompletedState extends ReviewState {
  final List<UserReviewEntity> reviews;
  final double averageRating;

  GetUserReviewDataCompletedState(this.reviews, this.averageRating);
}

class GetPostReviewState extends ReviewState {
  final List<PostReviewEntity> reviews;
  final List<UserEntity> users;

  GetPostReviewState(this.reviews, this.users);
}
class GetReviewByUserReviewIdCompletedState extends ReviewState {
  final UserReviewEntity review;

  GetReviewByUserReviewIdCompletedState(this.review);
}

class GetReviewByPostReviewIdCompletedState extends ReviewState {
  final PostReviewEntity review;
  GetReviewByPostReviewIdCompletedState(this.review);
}


class GetTestersReviewDataCompletedState extends ReviewState {
  final List<UserEntity> users;
  final List<UserReviewEntity> reviews;


  GetTestersReviewDataCompletedState({required this.users, required this.reviews});
}

class CreateUserReviewCompletedState extends ReviewState {
  final UserReviewEntity review;

  CreateUserReviewCompletedState(this.review);
}

class CreateRecruitPostReviewCompletedState extends ReviewState {
  final PostReviewEntity review;

  CreateRecruitPostReviewCompletedState(this.review);
}

class CreatePromotionPostReviewCompletedState extends ReviewState {
  final PostReviewEntity review;

  CreatePromotionPostReviewCompletedState(this.review);
}
class ReviewInitDataCompletedState extends ReviewState {
  final ResReviewInitEntity initData;

  ReviewInitDataCompletedState({required this.initData});
}

