

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

}
class GoogleLoginEvent extends AuthEvent {
  final UserEntity user;
  GoogleLoginEvent(this.user);
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