

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

class PasswordUpdateEvent extends AuthEvent {
  final String token;
  final String userId;
  final String oldPw;
  final String newPw;

  PasswordUpdateEvent(this.token, this.userId, this.oldPw, this.newPw);
}
class PasswordChangeEvent extends AuthEvent {
  final String email;
  final String newPw;
  PasswordChangeEvent(this.email, this.newPw);
}

class RequestUserDeleteEvent extends AuthEvent {
  final String token;
  final String userId;
  RequestUserDeleteEvent(this.token, this.userId);
}

class FindEmailEvent extends AuthEvent {
  final String nickname;
  FindEmailEvent(this.nickname);
}
class FindPasswordEvent extends AuthEvent {
  final String email;
  FindPasswordEvent(this.email);
}

class VerifyOtpEvent extends AuthEvent {
  final String email;
  final String otp;
  VerifyOtpEvent(this.email, this.otp);
}

class VerifyPasswordEvent extends AuthEvent {
  final String token;
  final String userId;
  final String password;
  VerifyPasswordEvent(this.token, this.userId, this.password);
}

class LogoutEvent extends AuthEvent {
  LogoutEvent();
}

class LoginFailedEvent extends AuthEvent {
  LoginFailedEvent();
}