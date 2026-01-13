import 'package:test_us_app/domain/entities/package/recruit_post_tester_reviews_entity.dart';
import 'package:test_us_app/domain/entities/recruit_post_entity.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';

import '../../../data/models/package/recruit_post_tester_reviews_model.dart';
import '../../../domain/entities/application_entity.dart';

enum UserAppState {
  startServiceState,
  applicationsInitState,
  applicationCompletedState,
  applicationUpdateCompletedState,
  applicationCancelCompletedState,
  applicationRejectCompletedState,
  getUserApplicationsCompletedState,
  loadingState,
  requestCompletedState,
  errorState
}

class AppState {
  UserAppState state;
  ApplicationEntity? application;
  List<ApplicationEntity>? applications;
  RecruitPostEntity? post;

  AppState({this.state = UserAppState.startServiceState, this.application, this.applications, this.post});
}

class GetRecruitPostTestersReviewState extends AppState {
  List<RecruitPostTesterReviewsEntity> info;

  GetRecruitPostTestersReviewState({required this.info});
}
// class GetRecruitApplicationsState extends AppState {
//   List<UserEntity> users;
//   List<ApplicationEntity> apps;
//   GetRecruitApplicationsState({required this.users, required this.apps});
// }