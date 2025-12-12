
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_us_app/domain/entities/image_entity.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';

class UserEvent {}

class CreateFirebaseTokenEvent extends UserEvent {
  final String? token;
  final String? messagingToken;
  final String? userId;
  final String? deviceType;

  CreateFirebaseTokenEvent(this.token, this.messagingToken, this.userId, this.deviceType);
}

class RemoveFirebaseTokenEvent extends UserEvent {
  final String? token;
  final String? userId;
  final String? messagingToken;

  RemoveFirebaseTokenEvent(this.token, this.userId, this.messagingToken);
}

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

class RequestUserInfoUpdateEvent extends UserEvent {
  final String token;
  final UserEntity userInfo;
  final XFile? profileImage;
  final ImageEntity? oldImage;
  RequestUserInfoUpdateEvent(this.token, this.userInfo, {this.profileImage, this.oldImage});
}

class RequestUserInfoByEmail extends UserEvent {
  final String email;
  RequestUserInfoByEmail(this.email);
}

class UserRequestCompleteEvent extends UserEvent {
  UserRequestCompleteEvent();
}