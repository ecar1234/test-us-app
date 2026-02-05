
import '../../../domain/entities/user_entity.dart';

enum UserAuthState {
  loadingState,
  serviceStartState,
  beforeLoginState,
  emailLoginLoadingState,
  googleAuthPendingState,
  naverAuthPendingState,
  authCompletedState,
  startLoginState,
  loginCompletedState,
  authLoginCompletedState,
  authCanceledState,
  passwordUpdateCompletedState,
  userDeleteCompletedState,
  logoutState,
  loginFailedState,
  authFailedState,
  errorState,
}

class AuthState {
  final UserAuthState state;
  final UserEntity? user;
  final String? token;
  final String? message;
  AuthState({this.state = UserAuthState.beforeLoginState, this.user, this.token, this.message});
}

