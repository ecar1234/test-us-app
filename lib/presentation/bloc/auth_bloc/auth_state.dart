
enum UserAuthState {serviceStartState, beforeLoginState, authPendingState, loginCompletedState, logoutState}

class AuthState {
  final UserAuthState state;
  AuthState({this.state = UserAuthState.beforeLoginState});
}

