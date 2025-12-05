import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';
import 'package:test_us_app/domain/use_cases/user_usecase.dart';
import 'package:test_us_app/presentation/bloc/user_bloc/user_event.dart';
import 'package:test_us_app/presentation/bloc/user_bloc/user_state.dart';

import '../../../domain/use_cases/review_usecase.dart';
import '../../provider/user_provider.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final logger = Logger();
  UserBloc(UserUseCase userUseCase, ReviewUseCase reviewUseCase) : super(UserState(UserDataState.serviceStartState)) {

    on<RequestUserDataEvent>((event, emit) async {
      emit(UserState(UserDataState.loadingState));
      logger.i('user state : loading state');
      try {
        final user = await userUseCase.getUserById(event.token, event.userId);
        emit(UserState(UserDataState.getUsersInfoCompletedState, user: user));
        logger.i('user state : getUsersInfoCompletedState');
      } catch (e) {
        emit(UserState(UserDataState.errorState));
        logger.i('user state : error state');
        logger.e(e);
      }
    });

    on<RequestUsersDataEvent>((event, emit) async {
      emit(UserState(UserDataState.loadingState));
      logger.i('user state : loading state');
      try {
        final users = await userUseCase.getUsersByIds(event.token, event.ids);
        // final reviews = await reviewUseCase.getTestersReviewOnPost(event.token, event.ids, event.postId);
        emit(UserState(UserDataState.getUsersInfoCompletedState,users: users));
        } catch (e) {
        emit(UserState(UserDataState.errorState));
        logger.i('user state : error state');
        logger.e(e);
      }
    });

    on<RequestUserInfoUpdateEvent>((event, emit) async {
      emit(UserState(UserDataState.loadingState));
      logger.i('user state : loading state');
      try {
        UserEntity user = UserEntity();
        if(event.profileImage == null){
           user = await userUseCase.updateUserInfo(event.token, event.userInfo);
        }else {
          if(event.oldImage != null){
            user = await userUseCase.updateUserInfoWithImage(event.token, event.userInfo, event.profileImage!, oldImage: event.oldImage!);
          }else{
            user = await userUseCase.updateUserInfoWithImage(event.token, event.userInfo, event.profileImage!);
          }
        }
        emit(UserState(UserDataState.getUsersInfoCompletedState, user: user));
        logger.i('user state : getUsersInfoCompletedState');
      } catch (e) {
        emit(UserState(UserDataState.errorState));
        logger.i('user state : error state');
        logger.e(e);
      }
    });

    on<RequestUserInfoByEmail>((event, emit)async {
      emit(UserState(UserDataState.loadingState));
      logger.i('user state : loading state');
      final user = await userUseCase.getUserByEmail(event.email);
      emit(UserState(UserDataState.getUsersInfoCompletedState, user: user));
    });

    on<UserRequestCompleteEvent>((event, emit) {
      emit(UserState(UserDataState.userDataLoadedState));
    });
  }
}
