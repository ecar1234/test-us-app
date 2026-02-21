import 'package:flutter/material.dart';
import 'package:test_us_app/domain/entities/application_entity.dart';
import 'package:test_us_app/domain/entities/recruit_post_entity.dart';

class AppEvent{}

class RequestApplyEvent extends AppEvent{
  final String token;
  final ApplicationEntity application;
  RequestApplyEvent(this.token, this.application);
}

class RequestUpdateApplicationEvent extends AppEvent{
  final String token;
  final ApplicationEntity application;
  RequestUpdateApplicationEvent(this.token, this.application);
}

class RequestCancelEvent extends AppEvent {
  final String token;
  final int appId;
  RequestCancelEvent(this.token, this.appId);
}

class RequestCompleteApplicationEvent extends AppEvent {
  final String token;
  final String userId;
  final String postId;
  final int appId;
  RequestCompleteApplicationEvent(this.token, this.userId, this.postId, this.appId);
}

class RequestRejectApplicationEvent extends AppEvent {
  final String token;
  final String userId;
  final String postId;
  final int appId;
  RequestRejectApplicationEvent(this.token, this.userId, this.postId, this.appId);
}

class RequestMyApplicationsEvent extends AppEvent {
  final String token;
  final String userId;

  RequestMyApplicationsEvent(this.token, this.userId);
}

class RequestRecruitPostTestersReviewEvent extends AppEvent {
  List<int> applicationIds;
  String token;

  RequestRecruitPostTestersReviewEvent(this.applicationIds, this.token);
}
// class RequestRecruitApplicationsEvent extends AppEvent {
//   final String token;
//   final List<int> applicationIds;
//
//   RequestRecruitApplicationsEvent(this.token, this.applicationIds);
// }


// class RequestPostByApplicationIdsEvent extends AppEvent {
//   final String token;
//   final List<int> applicationIds;
//
//   RequestPostByApplicationIdsEvent(this.token, this.applicationIds);
// }

class ApplicationDataLoadEvent extends AppEvent {
  ApplicationDataLoadEvent();
}
class RequestCompletedEvent extends AppEvent {
  RequestCompletedEvent();
}

class RequestErrorEvent extends AppEvent {
  RequestErrorEvent();
}
