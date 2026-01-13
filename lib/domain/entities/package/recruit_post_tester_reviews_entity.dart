

import 'package:test_us_app/data/models/package/recruit_post_tester_reviews_model.dart';

import '../../../data/models/package/recruit_post_applications_model.dart';
import '../user_review_entity.dart';

class RecruitPostTesterReviewsEntity {
  User? user;
  UserReviewEntity? userReview;
  int? appId;

  RecruitPostTesterReviewsEntity({this.user, this.userReview, this.appId});

  RecruitPostTesterReviewsEntity toEntity(RecruitPostTesterReviewsModel model) {
    final review = model.review == null ? null :  UserReviewEntity(
      reviewId: model.review!.reviewId,
      rating: model.review!.rating,
      comment: model.review!.comment,
      reviewedId: model.review!.reviewedUserId,
      reviewerId: model.review!.reviewerUserId,
      createdAt: model.review!.createdAt,
    );
    return RecruitPostTesterReviewsEntity(
        user: model.user,
        userReview: review,
        appId: model.appId
    );
  }
}