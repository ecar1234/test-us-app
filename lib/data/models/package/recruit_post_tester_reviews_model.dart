

import 'package:json_annotation/json_annotation.dart';
import 'package:test_us_app/data/models/package/recruit_post_applications_model.dart';
import 'package:test_us_app/data/models/review/user_review_model.dart';
part 'recruit_post_tester_reviews_model.g.dart';



@JsonSerializable()
class RecruitPostTesterReviewsModel {
  User? user;
  UserReviewModel? review;
  int? appId;


  RecruitPostTesterReviewsModel({this.user, this.review, this.appId});

  factory RecruitPostTesterReviewsModel.fromJson(Map<String, dynamic> json) => _$RecruitPostTesterReviewsModelFromJson(json);
}