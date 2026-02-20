
import '../../../domain/entities/message_entity.dart';
import '../../../domain/entities/room_entity.dart';

enum MessageLoadState {
  serviceStartState,
  dataLoadState,
  getRoomListCompletedState,
  getRoomMessagesCompletedState,
  getRoomInfoCompletedState,
  roomDeleteCompletedState,
  errorState,
  failedState
}


class MessageBlocState {
  MessageLoadState state;
  MessageBlocState({this.state = MessageLoadState.serviceStartState});
}
// room
class RoomListLoadCompletedState extends MessageBlocState {
  List<RoomEntity> roomList;

  RoomListLoadCompletedState({this.roomList = const []}) : super(state: MessageLoadState.getRoomListCompletedState);
}
class RoomInfoLoadCompletedState extends MessageBlocState {
  RoomEntity room;
  RoomInfoLoadCompletedState(this.room) : super(state: MessageLoadState.getRoomInfoCompletedState);
}
class RoomDeleteCompletedState extends MessageBlocState {
  int roomId;

  RoomDeleteCompletedState(this.roomId) : super(state: MessageLoadState.roomDeleteCompletedState);
}

// message
class RoomMessagesLoadCompletedState extends MessageBlocState {
  List<MessageEntity> messageList;

  RoomMessagesLoadCompletedState({this.messageList = const []}) : super(state: MessageLoadState.getRoomMessagesCompletedState);
}