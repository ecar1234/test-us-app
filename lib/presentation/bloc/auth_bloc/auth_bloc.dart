import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_naver_login/interface/types/naver_login_result.dart';
import 'package:flutter_naver_login/interface/types/naver_login_status.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/data/models/user/user_model.dart';
import 'package:test_us_app/domain/entities/image_entity.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';
import 'package:test_us_app/domain/use_cases/user_usecase.dart';

import '../../../data/sharedPreferences/auth_preference.dart';
import '../../../data/sharedPreferences/firebase_messaging_preference.dart';
import '../../provider/user_provider.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final pref = AuthPreference.instance;
  final firebasePref = FirebaseMessagingPreference.instance;
  final logger = Logger();

  AuthBloc(UserUseCase userUseCase) : super(AuthState(state: UserAuthState.serviceStartState)) {
    on<TokenCheckEvent>((event, emit) async {
      try {
        final token = await pref.getToken();
        if (token.isEmpty) {
          emit(AuthState(state: UserAuthState.beforeLoginState));
          return;
        } else {
          final serverToken = await userUseCase.autoLogin(token);
          if (serverToken != token) {
            pref.setToken(serverToken);
            logger.d('token changed!');
          }
          final user = await pref.getUserInfo();
          emit(AuthState(state: UserAuthState.loginCompletedState, user: user, token: serverToken));
        }
      } on Exception catch (e) {
        logger.e(e);
        emit(AuthState(state: UserAuthState.errorState, message: e.toString()));
      }
    });

    on<EmailLoginEvent>((event, emit) async {
      emit(AuthState(state: UserAuthState.emailLoginLoadingState));
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
      emit(AuthState(state: UserAuthState.googleAuthPendingState));
      logger.i('state : auth pending state');
      try {
        await GetIt.I.get<GoogleSignIn>().initialize();

        GoogleSignInAccount googleUser;
        if (GoogleSignIn.instance.supportsAuthenticate()) {
          googleUser = await GetIt.I.get<GoogleSignIn>().authenticate(scopeHint: ['email', 'profile']);
          logger.i('Google Sign-In: Used authenticate()');
        } else {
          emit(AuthState(state: UserAuthState.authFailedState, message: '구글 로그인 정보를 가져오지 못했습니다. 다시 시도해주세요.'));
          logger.i('Google Sign-In: Used signIn() as fallback');
          return;
        }

        final findUser = await userUseCase.getUserByEmail(googleUser.email);
        if (findUser != null) {
          final loginRes = await userUseCase.authLogin(
            googleUser.email,
            AuthType.google,
          );

          final user = loginRes['user'] as UserEntity;
          final token = loginRes['token'] as String;
          await pref.setToken(token);
          await pref.setUserInfo(user);
          emit(AuthState(state: UserAuthState.loginCompletedState, user: user, token: token));
          return;
        }

        final userInfo = UserEntity(
            email: googleUser.email,
            nickname: googleUser.displayName,
            profileImg: ImageEntity(url: googleUser.photoUrl));
        emit(AuthState(state: UserAuthState.authLoginCompletedState, user: userInfo, message: 'google'));
        logger.i('state : Google login completed state');
      } catch (e) {
        logger.e(e);
        logger.i('state : login failed state');
        // emit(AuthState(state: UserAuthState.authFailedState, message: '구글 로그인 정보를 가져오지 못했습니다. 다시 시도해주세요.'));
        emit(AuthState(state: UserAuthState.authFailedState, message: e.toString()));
      }
    });

    on<RequestNaverAuth>((event, emit) async {
      emit(AuthState(state: UserAuthState.naverAuthPendingState));
      try {
        final NaverLoginResult naverUser = await FlutterNaverLogin.logIn();
        if (naverUser.status == NaverLoginStatus.error) {
          emit(AuthState(state: UserAuthState.authFailedState, message: naverUser.errorMessage));
          return;
        }

        final findUser = await userUseCase.getUserByEmail(naverUser.account!.email!);
        if (findUser != null) {
          final loginRes = await userUseCase.authLogin(
            naverUser.account!.email!,
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
            email: naverUser.account!.email,
            nickname: naverUser.account!.name,
            profileImg: ImageEntity(url: naverUser.account!.profileImage));
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
      emit(AuthState(state: UserAuthState.startLoginState));
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

    on<LoginCompletedEvent>((event, emit) {
      emit(AuthState(state: UserAuthState.loginCompletedState, user: event.user));
    });

    on<LogoutEvent>((event, emit) async {
      try {
        await GetIt.I.get<GoogleSignIn>().signOut();
        await GetIt.I.get<GoogleSignIn>().disconnect();
        await FlutterNaverLogin.logOut();

        await pref.removeToken();
        await pref.removeUserInfo();
        await firebasePref.removeFirebaseToken();
        emit(AuthState(state: UserAuthState.logoutState));
        logger.i('state : logout state');
      } on Exception catch (e) {
        logger.e(e);
        emit(AuthState(state: UserAuthState.authFailedState));
      }
    });

    on<PasswordUpdateEvent>((event, emit) async {
      emit(AuthState(state: UserAuthState.loadingState));
      logger.i('state : loading state');
      try {
        final isPwValid = await userUseCase.isPasswordValid(event.token, event.userId, event.oldPw);
        if (!isPwValid) {
          emit(AuthState(state: UserAuthState.authFailedState, message: '기존 비밀번호가 일치하지 않습니다.'));
          logger.e('기존 비밀번호가 일치하지 않습니다.');
          return;
        }
        logger.i('password is valid');
        final res = await userUseCase.updatePassword(event.token, event.userId, event.newPw);
        if (res) {
          emit(AuthState(state: UserAuthState.passwordUpdateCompletedState));
          logger.i('state : password update completed state');
        } else {
          emit(AuthState(state: UserAuthState.errorState, message: '비밀번호 변경에 실패했습니다.'));
        }
      } on Exception catch (e) {
        logger.e(e.toString());
        emit(AuthState(state: UserAuthState.errorState, message: e.toString()));
      }
    });
    on<PasswordChangeEvent>((event, emit) async {
      emit(AuthState(state: UserAuthState.loadingState));
      logger.i('state : loading state');
      try {
        final res = await userUseCase.changePassword(event.email, event.newPw);
        if (res) {
          emit(AuthState(state: UserAuthState.passwordUpdateCompletedState));
          logger.i('state : password update completed state');
        } else {
          emit(AuthState(state: UserAuthState.errorState, message: '비밀번호 변경에 실패했습니다.'));
        }
      } on Exception catch (e) {
        logger.e(e.toString());
        emit(AuthState(state: UserAuthState.errorState, message: e.toString()));
      }
    });

    on<RequestUserDeleteEvent>((event, emit) async {
      emit(AuthState(state: UserAuthState.loadingState));
      try {
        final res = await userUseCase.deleteUser(event.token, event.userId);
        if (res) {
          add(LogoutEvent());
          emit(AuthState(state: UserAuthState.userDeleteCompletedState));
        } else {}
      } on Exception catch (e) {
        logger.e(e.toString());
        emit(AuthState(state: UserAuthState.errorState, message: e.toString()));
      }
    });

    on<FindEmailEvent>((event, emit) async {
      emit(AuthState(state: UserAuthState.loadingState));
      logger.i('state : loading state');
      try {
        final email = await userUseCase.findEmail(event.nickname);
        if (email.contains('found')) {
          emit(AuthState(state: UserAuthState.failedState, message: '해당 닉네임을 가진 유저가 없습니다.'));
          logger.e('state : failed state');
          return;
        }
        emit(FindEmailCompletedState(email));
        logger.i('state : find email completed state');
      } on Exception catch (e) {
        logger.e(e.toString());
        emit(AuthState(state: UserAuthState.errorState, message: e.toString()));
      }
    });
    on<FindPasswordEvent>((event, emit) async {
      emit(AuthState(state: UserAuthState.loadingState));
      logger.i('state : loading state');
      try {
        final res = await userUseCase.findPassword(event.email);
        if (!res) {
          emit(AuthState(state: UserAuthState.failedState, message: '해당 이메일을 가진 유저가 없습니다.'));
          logger.e('state : failed state');
          return;
        }
        emit(FindPasswordCompletedState(res));
        logger.i('state : find password completed state');
      } on Exception catch (e) {
        emit(AuthState(state: UserAuthState.errorState, message: e.toString()));
      }
    });
    on<VerifyOtpEvent>((event, emit) async {
      emit(AuthState(state: UserAuthState.loadingState));
      logger.i('state : loading state');
      try {
        final res = await userUseCase.verifyOtp(event.email, event.otp);
        if (!res) {
          emit(AuthState(state: UserAuthState.failedState, message: '인증번호가 일치하지 않습니다.'));
          logger.e('state : failed state');
          return;
        }
        emit(VerifyOtpCompletedState(res));
        logger.i('state : verify otp completed state');
      } on Exception catch (e) {
        emit(AuthState(state: UserAuthState.errorState, message: e.toString()));
        logger.e(e.toString());
      }
    });
  }
}
