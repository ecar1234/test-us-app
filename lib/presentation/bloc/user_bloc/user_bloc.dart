import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/domain/use_cases/user_usecase.dart';
import 'package:test_us_app/presentation/bloc/user_bloc/user_event.dart';
import 'package:test_us_app/presentation/bloc/user_bloc/user_state.dart';

import '../../provider/user_provider.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final logger = Logger();
  UserBloc(UserUseCase userUseCase) : super(UserState(UserDataState.serviceStartState)) {
    on<RequestUserDataEvent>((event, emit) async {
      emit(UserState(UserDataState.loadingState));
      try {
        final user = await userUseCase.getUserById(event.token, event.userId);
        emit(UserState(UserDataState.getUsersInfoCompletedState, user: user));
      } catch (e) {
        emit(UserState(UserDataState.errorState));
      }
    });

    on<RequestUsersDataEvent>((event, emit) async {
      emit(UserState(UserDataState.loadingState));
      try {
        final data = await userUseCase.getUsersByIds(event.token, event.ids);
        emit(UserState(UserDataState.getUsersInfoCompletedState, usersAddAverage: data));
        } catch (e) {
        logger.e(e);
        emit(UserState(UserDataState.errorState));
      }
    });

    on<UserRequestCompleteEvent>((event, emit) {
      emit(UserState(UserDataState.userDataLoadedState));
    });
  }
}
