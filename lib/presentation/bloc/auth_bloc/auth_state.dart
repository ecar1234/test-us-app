
enum UserAuthState {serviceStartState, beforeLoginState, loginCompletedState, logoutState}

class AuthState {
  final UserAuthState state;
  AuthState({this.state = UserAuthState.beforeLoginState});
}

