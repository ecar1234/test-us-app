


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';
import 'package:test_us_app/domain/use_cases/user_usecase.dart';

import '../../../data/sharedPreferences/auth_preference.dart';
import '../../provider/user_provider.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  final pref = AuthPreference.instance;
  final logger = Logger();
  AuthBloc(UserUseCase userUseCase): super (AuthState(state: UserAuthState.serviceStartState)){
    on<TokenCheckEvent>((event, emit) async {
      final token = await pref.getToken();
      if(token.isEmpty){
        emit(AuthState(state: UserAuthState.beforeLoginState));
        return;
      }else {
        final user = await pref.getUserInfo();
        emit(AuthState(state: UserAuthState.loginCompletedState, user: user, token: token));
      }
    });
    on<LoginEvent>((event, emit) async {
      emit(AuthState(state: UserAuthState.authPendingState));
      try{
        final res = await userUseCase.login(event.email, event.password);
        if(res['token'] == null){
          emit(AuthState(state: UserAuthState.loginFailedState));
          return;
        }
        final user = res['user'] as UserEntity;
        final token = res['token'] as String;
        await pref.setToken(token);
        await pref.setUserInfo(user);
        emit(AuthState(state: UserAuthState.loginCompletedState, user: user, token: token));
      }catch(e){
        emit(AuthState(state: UserAuthState.loginFailedState));
      }

    });
    on<LoginCompletedEvent>((event, emit) {
      emit(AuthState(state: UserAuthState.loginCompletedState, user: event.user));
    });
    on<LogoutEvent>((event, emit) async {
      await pref.removeToken();
      await pref.removeUserInfo();
      emit(AuthState(state: UserAuthState.logoutState));
    });
  }
}