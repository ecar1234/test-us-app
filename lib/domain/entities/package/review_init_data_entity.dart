import 'package:test_us_app/data/models/review/packages/res_review_init_model.dart';
import 'package:test_us_app/domain/entities/post_review_entity.dart';
import 'package:test_us_app/domain/entities/recruit_review_average_entity.dart';
import 'package:test_us_app/domain/entities/user_review_entity.dart';

class ResReviewInitEntity {
  final List<UserReviewEntity>? userReviews;
  final List<RecruitReviewAverageEntity>? postReviewAverages;
  final List<PostReviewEntity>? applyPostReviews;

  ResReviewInitEntity({this.userReviews, this.postReviewAverages, this.applyPostReviews});

  static ResReviewInitEntity toEntity(ResReviewInitModel model) {
    final userReviews = model.userReviews?.map((review) => UserReviewEntity.toEntity(review)).toList();
    final List<RecruitReviewAverageEntity>? postReviewAverage = model.postReviewAverages?.map((average) => RecruitReviewAverageEntity.toEntity(average)).toList();
    final applyPostReviews = model.applyPostReviews?.map((review) => PostReviewEntity.toEntity(review)).toList();
    return ResReviewInitEntity(
      userReviews: userReviews ?? [],
      postReviewAverages: postReviewAverage??[],
      applyPostReviews: applyPostReviews ?? [],
    );
  }
}
