
import '../../../domain/entities/room_entity.dart';

enum MessageLoadState {
  serviceStartState,
  dataLoadState,
  getRoomListCompletedState,
  errorState,
}


class MessageBlocState {
  MessageLoadState state;
  MessageBlocState({this.state = MessageLoadState.serviceStartState});
}

class RoomListLoadCompletedState extends MessageBlocState {
  List<RoomEntity> roomList;
  RoomListLoadCompletedState({this.roomList = const []}) : super(state: MessageLoadState.getRoomListCompletedState);
}