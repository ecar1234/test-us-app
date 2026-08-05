
import 'package:flutter/material.dart';
import 'package:test_us_app/domain/entities/application_entity.dart';
import 'package:test_us_app/domain/entities/recruit_post_entity.dart';

import '../../data/models/review/post_review_model.dart';
import '../../domain/entities/post_review_entity.dart';
import '../../domain/use_cases/application_usecase.dart';

class ApplicationProvider with ChangeNotifier{
  final ApplicationUseCase useCase;
  ApplicationProvider(this.useCase);

  List<ApplicationEntity>? _userApplications;
  List<RecruitPostEntity>? _userApplicationPosts;
  List<ApplicationEntity>? get userApplications => _userApplications;
  List<RecruitPostEntity>? get userApplicationPosts => _userApplicationPosts;


  void setMyApplications(List<ApplicationEntity> applications) async {
    _userApplications = applications;
    notifyListeners();
  }

  void logout(){
    if(_userApplications != null && _userApplications!.isNotEmpty){
      _userApplications!.clear();
      _userApplications = [];
    }
    // if(_userApplicationPosts != null && _userApplicationPosts!.isNotEmpty) {
    //   _userApplicationPosts!.clear();
    //   _userApplicationPosts = [];
    // }
    notifyListeners();
  }

  void requestApply(ApplicationEntity app)  {
    // final res = await useCase.requestApply(token, app);
    _userApplications ??= [];

    if(_userApplications == null){
      _userApplications = [app];
    }else {
      _userApplications!.add(app);
    }
    notifyListeners();
  }
  void cancelApplication(ApplicationEntity newApp)  {
    _userApplications ??= [];
    // _userApplicationPosts ??= [];

    if(_userApplications!.any((element) => element.id == newApp.id)){
      _userApplications = _userApplications!.where((element) => element.id != newApp.id).toList();
      _userApplications!.add(newApp);
    }
    // if(_userApplicationPosts!.any((element) => element.id == newApp.postId)){
    //   _userApplicationPosts = _userApplicationPosts!.where((element) => element.id != newApp.postId).toList();
    // }
    notifyListeners();
  }

  void requestUpdateApplication(ApplicationEntity app) {
    if(_userApplications!.any((element) => element.id == app.id)){
      final idx = _userApplications!.indexWhere((e) {
        return e.id == app.id;
      });
      _userApplications![idx] = app;
    }
    notifyListeners();
  }

  void setUserApplicationPosts(List<RecruitPostEntity> posts) {
    if(_userApplicationPosts == null || _userApplicationPosts!.isEmpty) {
      _userApplicationPosts = posts;
    }
    notifyListeners();
  }
  void addReviewToUserApplicationPost(PostReviewEntity review) {
    if(_userApplicationPosts!.any((e) => e.id == review.postId)) {
      final idx = _userApplicationPosts!.indexWhere((e) => e.id == review.postId);
      final post = _userApplicationPosts![idx];
      // final reviewEntity = RecruitReviewEntity(
      //   reviewId: review.reviewId,
      //   postId: review.postId,
      //   reviewerUserId: review.reviewerUserId,
      //   rating: review.rating,
      // );
      final updatePost = RecruitPostEntity(
        id: post.id,
        title: post.title,
        contents: post.contents,
        author: post.author,
        platform: post.platform,
        mobileOs: post.mobileOs,
        category: post.category,
        status: post.status,
        period: post.period,
        views: post.views,
        applications: post.applications,
        images: post.images,
        // reviews: [...post.reviews!, reviewEntity],
        createdAt: post.createdAt,
        updatedAt: post.updatedAt,
      );
      _userApplicationPosts![idx] = updatePost;
      _userApplicationPosts = List.from(_userApplicationPosts!);
    }
    notifyListeners();
  }

  Future<void> completeApplication(String token, String appId) async {}

  Future<void> rejectApplication(String token, String appId) async {}

}