
import 'package:test_us_app/data/models/review/recruit_review_average_model.dart';

class RecruitReviewAverageEntity {
  String? postId;
  double? average;

  RecruitReviewAverageEntity({
    this.postId,
    this.average
  });

  static RecruitReviewAverageEntity toEntity(RecruitReviewAverageModel model){
    return RecruitReviewAverageEntity(
      postId: model.postId,
      average: model.average
    );
  }

}