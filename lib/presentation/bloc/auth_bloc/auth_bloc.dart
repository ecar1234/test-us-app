import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_naver_login/interface/types/naver_login_status.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/data/models/user/user_model.dart';
import 'package:test_us_app/domain/entities/image_entity.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';
import 'package:test_us_app/domain/use_cases/user_usecase.dart';

import '../../../data/sharedPreferences/auth_preference.dart';
import '../../provider/user_provider.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final pref = AuthPreference.instance;
  final logger = Logger();

  AuthBloc(UserUseCase userUseCase) : super(AuthState(state: UserAuthState.serviceStartState)) {
    on<TokenCheckEvent>((event, emit) async {
      final token = await pref.getToken();
      if (token.isEmpty) {
        emit(AuthState(state: UserAuthState.beforeLoginState));
        return;
      } else {
        final user = await pref.getUserInfo();
        emit(AuthState(state: UserAuthState.loginCompletedState, user: user, token: token));
      }
    });

    on<EmailLoginEvent>((event, emit) async {
      emit(AuthState(state: UserAuthState.authPendingState));
      try {
        final res = await userUseCase.login(event.email, event.password);
        if (res['message'] != null) {
          emit(AuthState(state: UserAuthState.loginFailedState, message: res['message']));
          return;
        }
        final user = res['user'] as UserEntity;
        final token = res['token'] as String;
        await pref.setToken(token);
        await pref.setUserInfo(user);
        emit(AuthState(state: UserAuthState.loginCompletedState, user: user, token: token));
        logger.i('state : login completed state');
      } catch (e) {
        emit(AuthState(state: UserAuthState.loginFailedState, message: '알 수 없는 문제로 로그인 실패, 다시 시도해주세요.'));
        logger.e(e);
        logger.i('state : login failed state');
      }
    });

    on<RequestGoogleAuth>((event, emit) async {
      emit(AuthState(state: UserAuthState.authPendingState));
      logger.i('state : auth pending state');
      try {
        GoogleSignInAccount authUser;
        if (GoogleSignIn.instance.supportsAuthenticate()) {
          authUser = await GetIt.I.get<GoogleSignIn>().authenticate(scopeHint: ['email', 'profile']);
          logger.i('Google Sign-In: Used authenticate()');
        } else {
          emit(AuthState(state: UserAuthState.authFailedState));
          logger.i('Google Sign-In: Used signIn() as fallback');
          return;
        }

        final userInfo = UserEntity(
            email: authUser.email, userName: authUser.displayName, profileImg: ImageEntity(url: authUser.photoUrl));
        emit(AuthState(state: UserAuthState.authLoginCompletedState, user: userInfo, message: 'google'));
        logger.i('state : Google login completed state');
      } catch (e) {
        logger.e(e);
        logger.i('state : login failed state');
        emit(AuthState(state: UserAuthState.authFailedState, message: '구글 로그인 정보를 가져오지 못했습니다. 다시 시도해주세요.'));
      }
    });
    on<RequestNaverAuth>((event, emit) async {
      emit(AuthState(state: UserAuthState.authPendingState));
      try {
        final authUser = await FlutterNaverLogin.logIn();
        if (authUser.status == NaverLoginStatus.error) {
          emit(AuthState(state: UserAuthState.authFailedState, message: '네이버 로그인 정보를 가져오지 못했습니다. 다시 시도해주세요.'));
          return;
        }

        final findUser = await userUseCase.getUserByEmail(authUser.account!.email!);
        if (findUser != null) {
          final loginRes = await userUseCase.authLogin(
            authUser.account!.email!,
            AuthType.naver,
          );

          final user = loginRes['user'] as UserEntity;
          final token = loginRes['token'] as String;
          await pref.setToken(token);
          await pref.setUserInfo(user);
          emit(AuthState(state: UserAuthState.loginCompletedState, user: user, token: token));
          return;
        }

        final userInfo = UserEntity(
            email: authUser.account!.email,
            nickname: authUser.account!.name,
            profileImg: ImageEntity(url: authUser.account!.profileImage));
        emit(AuthState(state: UserAuthState.authLoginCompletedState, user: userInfo, message: 'naver'));
        logger.i('state : Naver login completed state');
        return;
      } catch (e) {
        logger.e(e);
        logger.i('state : login failed state');
        emit(AuthState(state: UserAuthState.authFailedState, message: '네이버 유져 정보를 가져오지 못했습니다. 다시 시도해주세요.'));
      }
    });

    on<OauthLoginEvent>((event, emit) async {
      emit(AuthState(state: UserAuthState.authPendingState));
      try {
        final loginRes = await userUseCase.authSignup(event.user);
        final user = loginRes['user'] as UserEntity;
        final token = loginRes['token'] as String;
        await pref.setToken(token);
        await pref.setUserInfo(user);
        emit(AuthState(state: UserAuthState.loginCompletedState, user: user, token: token));
        return;
      } catch (e) {
        emit(AuthState(state: UserAuthState.loginFailedState, message: '알 수 없는 문제로 로그인 실패, 다시 시도해주세요.'));
        logger.e(e);
        logger.i('state : login failed state');
      }
    });

    on<RequestAuthLogoutEvent>((event, emit) async {
      emit(AuthState(state: UserAuthState.authPendingState));
      logger.i('state : auth pending state');
      try {
        if(event.user.method == AuthType.google){
          await GetIt.I.get<GoogleSignIn>().signOut();
        }else if(event.user.method == AuthType.naver){
          await FlutterNaverLogin.logOut();
        }
      } catch(error){
        logger.e(error);
        emit(AuthState(state: UserAuthState.authFailedState));
      }
    });

    on<LoginCompletedEvent>((event, emit) {
      emit(AuthState(state: UserAuthState.loginCompletedState, user: event.user));
    });

    on<LogoutEvent>((event, emit) async {
      await pref.removeToken();
      await pref.removeUserInfo();
      emit(AuthState(state: UserAuthState.logoutState));
      logger.i('state : logout state');
    });
  }
}
