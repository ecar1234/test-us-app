

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_us_app/presentation/provider/application_provider.dart';

import 'app_event.dart';
import 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState>{
  AppBloc(): super(AppState()) {
    on<RequestApplyEvent>((event, emit) async {
      emit(AppState(state: UserAppState.loadingState));
      final newPost = await event.context.read<ApplicationProvider>().requestApply(event.token, event.app);
      emit(AppState(state: UserAppState.requestCompletedState, newPost: newPost));
    });

    on<RequestApplyCancelEvent>((event, emit) async {
      emit(AppState(state: UserAppState.loadingState));
      final newPost = await event.context.read<ApplicationProvider>().cancelApplication(event.token, event.appId);
      emit(AppState(state: UserAppState.requestCompletedState, newPost: newPost));
    });

    on<RequestApplyUpdate>((event, emit) async {
      emit(AppState(state: UserAppState.loadingState));
      final newPost = await event.context.read<ApplicationProvider>().requestUpdateApplication(event.token, event.app);
      emit(AppState(state: UserAppState.requestCompletedState, newPost: newPost));
    });

    on<ApplyRejectEvent>((event, emit) {
      emit(AppState(state: UserAppState.requestCompletedState));
    });

    on<ApplyCompleteEvent>((event, emit) {
      emit(AppState(state: UserAppState.requestCompletedState));
    });

    on<RequestUserApplicationsEvent>((event, emit) async {
      emit(AppState(state: UserAppState.loadingState));
      await event.context.read<ApplicationProvider>().getMyApplications(event.token, event.userId);
      emit(AppState(state: UserAppState.userApplicationLoadCompletedState));
    });

    on<RequestCompletedEvent>((event, emit) {
      emit(AppState(state: UserAppState.userApplicationLoadCompletedState));
    });
  }
}