

import 'package:provider/provider.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';

import '../../../domain/entities/post_review_entity.dart';
import '../../../domain/entities/user_review_entity.dart';

class ReviewEvent {}

// note: 나의 테스터 리뷰
class RequestUserReviewEvent extends ReviewEvent {
  final String token;
  final String userId;

  RequestUserReviewEvent(this.token, this.userId);
}

// note: 테스터 모집 프로젝트 리뷰
class RequestPostReviewEvent extends ReviewEvent {
  final String token;
  final String postId;

  RequestPostReviewEvent(this.token, this.postId);
}

// note: 테스터 모집 프로젝트의 테스터들의 리뷰
// note: 내용이 있으면 불러오고 없다면 리뷰 작성 버튼으로 대체.
class RequestTestersReviewEvent extends ReviewEvent {
  final String token;
  final List<String> testerIds;
  final int appId;


  RequestTestersReviewEvent(this.token, this.testerIds, this.appId);
}
// note: 리뷰 아이디로 리뷰 가져오기
class RequestReviewByPostReviewIdEvent extends ReviewEvent {
  final String token;
  final String reviewId;

  RequestReviewByPostReviewIdEvent(this.token, this.reviewId);
}
class RequestReviewByUserReviewIdEvent extends ReviewEvent {
  final String token;
  final String reviewId;

  RequestReviewByUserReviewIdEvent(this.token, this.reviewId);
}

class CreateUserReviewEvent extends ReviewEvent {
  final String token;
  final UserReviewEntity review;

  CreateUserReviewEvent(this.token, this.review);
}

class CreateRecruitPostReviewEvent extends ReviewEvent {
  final String token;
  final PostReviewEntity review;

  CreateRecruitPostReviewEvent(this.token, this.review);
}

class CreatePromotionPostReviewEvent extends ReviewEvent {
  final String token;
  final PostReviewEntity review;

  CreatePromotionPostReviewEvent(this.token, this.review);
}

class ChangeStateToGetTestersReview extends ReviewEvent {
  final List<UserReviewEntity> reviews;
  final List<UserEntity> users;

  ChangeStateToGetTestersReview({required this.reviews, required this.users});
}
