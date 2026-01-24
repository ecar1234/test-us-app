

class MessageBlocEvent {}

class RequestRoomListEvent extends MessageBlocEvent {
  String userId;
  String token;

  RequestRoomListEvent(this.token, this.userId);
}