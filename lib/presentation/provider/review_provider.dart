

import 'package:flutter/cupertino.dart';

import '../../domain/entities/post_review_entity.dart';
import '../../domain/entities/user_review_entity.dart';
import '../../domain/use_cases/review_usecase.dart';

class ReviewProvider extends ChangeNotifier{
  final ReviewUseCase useCase;
  ReviewProvider(this.useCase);

  List<UserReviewEntity>? _userReviews;
  List<UserReviewEntity>? get userReviews => _userReviews;

  List<UserReviewEntity>? _testersReviewOnPost;
  List<UserReviewEntity>? get testersReviewOnPost => _testersReviewOnPost;

  List<PostReviewEntity>? _applicationPostReviews;
  List<PostReviewEntity>? get applicationPostReviews => _applicationPostReviews;



  void setUserReviews(List<UserReviewEntity> reviews) async {
    _userReviews = reviews;
    notifyListeners();
  }

  void setTestersReview(List<UserReviewEntity> reviews) async {
    _testersReviewOnPost = reviews;
    notifyListeners();
  }
  void updateTesterReview(UserReviewEntity review) async {
    _testersReviewOnPost ??= [];
    _testersReviewOnPost!.add(review);
    notifyListeners();
  }

  void setPostReviews(List<PostReviewEntity> reviews) async {
    _applicationPostReviews ??= reviews;
    notifyListeners();
  }

}