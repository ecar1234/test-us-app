

import 'package:flutter/cupertino.dart';
import 'package:test_us_app/data/sharedPreferences/auth_preference.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';

class AuthEvent {}

class TokenCheckEvent extends AuthEvent {
  TokenCheckEvent();
}
class LoginEvent extends AuthEvent {
  UserEntity user;
  LoginEvent(this.user);
}
class LoginCompletedEvent extends AuthEvent {
  BuildContext context;
  LoginCompletedEvent(this.context);
}

class LogoutEvent extends AuthEvent {
  BuildContext context;
  LogoutEvent(this.context);
}