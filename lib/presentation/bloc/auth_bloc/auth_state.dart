
import '../../../domain/entities/user_entity.dart';

enum UserAuthState {
  serviceStartState,
  beforeLoginState,
  authPendingState,
  authCompletedState,
  loginPendingState,
  loginCompletedState,
  authLoginCompletedState,
  authCanceledState,
  logoutState,
  loginFailedState,
  authFailedState
}

class AuthState {
  final UserAuthState state;
  final UserEntity? user;
  final String? token;
  final String? message;
  AuthState({this.state = UserAuthState.beforeLoginState, this.user, this.token, this.message});
}

