
import 'package:flutter/cupertino.dart';

class UserEvent {}

class RequestUserDataEvent extends UserEvent {
  String token;
  String userId;
  RequestUserDataEvent(this.token, this.userId);
}

class RequestUsersDataEvent extends UserEvent {
  String token;
  List<String> ids;
  RequestUsersDataEvent(this.token, this.ids);
}

class RequestUserReviewEvent extends UserEvent {
  String userId;
  RequestUserReviewEvent(this.userId);
}

class UserRequestCompleteEvent extends UserEvent {
  UserRequestCompleteEvent();
}