


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../data/sharedPreferences/auth_preference.dart';
import '../../provider/user_provider.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  final pref = AuthPreference.instance;
  final logger = Logger();
  AuthBloc(): super (AuthState(state: UserAuthState.serviceStartState)){
    on<TokenCheckEvent>((event, emit) async {
      final token = await pref.getToken();
      if(token.isEmpty){
        emit(AuthState(state: UserAuthState.beforeLoginState));
        logger.d('token is empty');
        return;
      }else {
        emit(AuthState(state: UserAuthState.loginCompletedState));
        logger.d('token is not empty');
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
      event.context.read<UserProvider>().logout();
      await pref.removeToken();
      await pref.removeUserInfo();
      emit(AuthState(state: UserAuthState.beforeLoginState));
    });
    // add(TokenCheckEvent());
  }
}