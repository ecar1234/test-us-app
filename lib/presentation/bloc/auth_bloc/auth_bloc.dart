


import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/sharedPreferences/auth_preference.dart';
import '../../provider/user_provider.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  final pref = AuthPreference.instance;

  AuthBloc(): super (AuthState(state: UserAuthState.serviceStartState)){
    on<TokenCheckEvent>((event, emit) async {
      final token = await pref.getToken();
      if(token.isEmpty){
        emit(AuthState(state: UserAuthState.beforeLoginState));
        return;
      }else {
        emit(AuthState(state: UserAuthState.loginCompletedState));
      }
    });
    on<LoginEvent>((event, emit) async {
      await pref.setUserInfo(event.user);
      emit(AuthState(state: UserAuthState.loginCompletedState));
    });
    on<LoginCompletedEvent>((event, emit) {

      emit(AuthState(state: UserAuthState.loginCompletedState));
    });
    on<LogoutEvent>((event, emit) async {
      await pref.removeToken();
      await pref.removeUserInfo();
      emit(AuthState(state: UserAuthState.beforeLoginState));
    });

  add(TokenCheckEvent());
  }
}