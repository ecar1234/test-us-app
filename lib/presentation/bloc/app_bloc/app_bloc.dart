

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/domain/use_cases/application_usecase.dart';
import 'package:test_us_app/domain/use_cases/recruit_post_usecase.dart';
import 'package:test_us_app/presentation/provider/application_provider.dart';

import '../../../data/sharedPreferences/auth_preference.dart';
import '../../../domain/use_cases/user_usecase.dart';
import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState>{
  final pref = AuthPreference.instance;
  final logger = Logger();
  AppBloc(ApplicationUseCase applicationUseCase, RecruitPostUseCase recruitPostUseCase, UserUseCase userUseCase): super(AppState()) {

    // on<ApplyRejectEvent>((event, emit) {
    //   emit(AppState(state: UserAppState.requestCompletedState));
    // });
    on<RequestMyApplicationsEvent>((event, emit) async {
      emit(AppState(state: UserAppState.loadingState));
      logger.i('application state: loadingState');

      final res = await applicationUseCase.getMyApplications(event.token, event.userId);
      emit(AppState(state: UserAppState.getUserApplicationsCompletedState, applications: res));
      logger.i('application state: getUserApplicationsCompletedState');
    });

    on<RequestApplyEvent>((event, emit) async {
      emit(AppState(state: UserAppState.loadingState));
      logger.i('application state: loadingState');
      final res = await applicationUseCase.requestApply(event.token, event.application);
      emit(AppState(state: UserAppState.applicationCompletedState, application: res['application'], post: res['post']));
      logger.i('application state: applicationCompletedState');
    });

    on<RequestUpdateApplicationEvent>((event, emit) async {
      emit(AppState(state: UserAppState.loadingState));
      logger.i('application state: loadingState');
      final res = await applicationUseCase.updateApplication(event.token, event.application);
      emit(AppState(state: UserAppState.applicationUpdateCompletedState, application: res['application'], post: res['post']));
      logger.i('application state: applicationUpdateCompletedState');
    });

    on<RequestRejectApplicationEvent>((event, emit) async {
      emit(AppState(state: UserAppState.loadingState, loadingAppId: event.appId));
      logger.i('application state: loadingState');
      final res = await applicationUseCase.rejectApplication(event.token, event.userId, event.postId);
      emit(AppState(state: UserAppState.applicationRejectCompletedState, application: res));
      logger.i('application state: applicationRejectCompletedState');
    });

    on<RequestCompleteApplicationEvent>((event, emit) async {
      emit(AppState(state: UserAppState.loadingState, loadingAppId: event.appId));
      logger.i('application state: loadingState');
      final res = await applicationUseCase.completeApplication(event.token, event.userId, event.postId);
      emit(AppState(state: UserAppState.applicationCompletedState, application: res));
      logger.i('application state: applicationCompletedState');
    });

    on<RequestCancelEvent>((event, emit) async {
      emit(AppState(state: UserAppState.loadingState, loadingAppId: event.appId));
      logger.i('application state: loadingState');
      final res = await applicationUseCase.cancelApply(event.token, event.appId);
      emit(AppState(state: UserAppState.applicationCancelCompletedState, application: res['application'], post: res['post']));
      logger.i('application state: applicationCancelCompletedState');
    });

    on<RequestRecruitPostTestersReviewEvent>((event, emit) async {
      emit(AppState(state: UserAppState.loadingState));
      logger.i('application state: loadingState');
      final res = await applicationUseCase.getTesterReviewsByAppIds(event.token, event.applicationIds);
      emit(GetRecruitPostTestersReviewState(info: res));
      logger.i('application state: getTesterReviewsCompletedState');
    });

    on<RequestCompletedEvent>((event, emit) {
      emit(AppState(state: UserAppState.requestCompletedState));
    });

    on<RequestErrorEvent>((event, emit) {
      emit(AppState(state: UserAppState.errorState));
    });




    // on<ApplicationDataLoadEvent>((event, emit) async {
    //   emit(AppState(state: UserAppState.loadingState));
    //   final token = await pref.getToken();
    //   final user = await pref.getUserInfo();
    //   final res = await applicationUseCase.getMyApplications(token, user.id!);
    //
    // });

    // on<RequestCompletedEvent>((event, emit) {
    //   emit(AppState(state: UserAppState.userApplicationLoadCompletedState));
    // });
  }
}