

import 'package:flutter/cupertino.dart';
import 'package:test_us_app/data/sharedPreferences/auth_preference.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';

class AuthEvent {}

class TokenCheckEvent extends AuthEvent {
  TokenCheckEvent();
}
class EmailLoginEvent extends AuthEvent {
  final String email;
  final String password;
  EmailLoginEvent(this.email, this.password);
}

class RequestGoogleAuth extends AuthEvent {
  RequestGoogleAuth();
}
class OauthLoginEvent extends AuthEvent {
  final UserEntity user;
  OauthLoginEvent({required this.user});
}

class RequestNaverAuth extends AuthEvent {
  RequestNaverAuth();
}

class RequestAuthLogoutEvent extends AuthEvent {
  final UserEntity user;
  RequestAuthLogoutEvent(this.user);
}

class LoginCompletedEvent extends AuthEvent {
  final UserEntity user;
  LoginCompletedEvent(this.user);
}

class LogoutEvent extends AuthEvent {
  LogoutEvent();
}

class LoginFailedEvent extends AuthEvent {
  LoginFailedEvent();
}