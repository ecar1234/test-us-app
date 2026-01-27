

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/domain/use_cases/message_usecase.dart';

import 'message_event.dart';
import 'message_state.dart';

class MessageBloc extends Bloc<MessageBlocEvent, MessageBlocState> {
  MessageBloc(MessageUseCase messageUseCase) : super(MessageBlocState(state: MessageLoadState.serviceStartState)) {
    final logger = Logger();

    on<RequestRoomListEvent>((event, emit)async {
      try {
        emit(MessageBlocState(state: MessageLoadState.dataLoadState));
        logger.i("data state : dataLoadState");
        final res = await messageUseCase.requestRoomList(event.token, event.userId);
        emit(RoomListLoadCompletedState(roomList: res));
        logger.i("data state : getRoomListCompletedState");
      } on Exception catch (e) {
        emit(MessageBlocState(state: MessageLoadState.errorState));
        logger.e("data state : errorState");
      }
    });

    on<RequestRoomMessagesByPostIdEvent>((event, emit) async {
      emit(MessageBlocState(state: MessageLoadState.dataLoadState));
      logger.i("data state : dataLoadState");
      try {
        final res = await messageUseCase.requestMessageByPostId(event.token, event.postId, event.targetId);
        emit(RoomMessagesLoadCompletedState(messageList: res));
        logger.i("data state : getMessageListCompletedState");
      } catch (error) {
        emit(MessageBlocState(state: MessageLoadState.errorState));
        logger.e("data state : errorState");
      }

    });
    on<RequestRoomMessagesByRoomIdEvent>((event, emit) async {
      emit(MessageBlocState(state: MessageLoadState.dataLoadState));
      logger.i("data state : dataLoadState");
      try {
        final res = await messageUseCase.requestMessageByRoomId(event.token, event.roomId);
        emit(RoomMessagesLoadCompletedState(messageList: res));
        logger.i("data state : getMessageListCompletedState");
      } catch (error) {
        emit(MessageBlocState(state: MessageLoadState.errorState));
        logger.e("data state : errorState");
      }
    });

  }
}