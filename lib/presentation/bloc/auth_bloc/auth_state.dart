
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
  findEmailCompletedState,
  findPasswordCompletedState,
  verifyOtpCompletedState,
  passwordCheckCompletedState,
  logoutState,
  loginFailedState,
  authFailedState,
  errorState,
  failedState,
}

class AuthState {
  final UserAuthState state;
  final UserEntity? user;
  final String? token;
  final String? message;
  AuthState({this.state = UserAuthState.beforeLoginState, this.user, this.token, this.message});
}

class FindEmailCompletedState extends AuthState {
  final bool result;
  FindEmailCompletedState(this.result) : super(state: UserAuthState.findEmailCompletedState);
}

class FindPasswordCompletedState extends AuthState {
  final bool isFound;
  FindPasswordCompletedState(this.isFound) : super(state: UserAuthState.findPasswordCompletedState);
}
class VerifyOtpCompletedState extends AuthState {
  final bool isVerified;
  VerifyOtpCompletedState(this.isVerified) : super(state: UserAuthState.passwordCheckCompletedState);
}

class PasswordCheckCompletedState extends AuthState {
  final bool isVerified;
  PasswordCheckCompletedState(this.isVerified) : super(state: UserAuthState.findPasswordCompletedState);
}


