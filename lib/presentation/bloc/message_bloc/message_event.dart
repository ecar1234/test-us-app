

class MessageBlocEvent {}

class RequestRoomListEvent extends MessageBlocEvent {
  String userId;
  String token;

  RequestRoomListEvent(this.token, this.userId);
}

class RequestRoomMessagesByPostIdEvent extends MessageBlocEvent {
  final String token;
  final String postId;
  final String targetId;

  RequestRoomMessagesByPostIdEvent(this.token, this.postId, this.targetId);
}
class RequestRoomMessagesByRoomIdEvent extends MessageBlocEvent {
  final String token;
  final int roomId;
  final String userId;


  RequestRoomMessagesByRoomIdEvent(this.token, this.roomId, this.userId);
}

class DeleteRoomEvent extends MessageBlocEvent {
  final String token;
  final int roomId;
  final String userId;

  DeleteRoomEvent(this.token, this.roomId, this.userId);
}
class ResetUnreadCount extends MessageBlocEvent {
  final String token;
  final int roomId;
  final String userId;

  ResetUnreadCount(this.token, this.roomId, this.userId);
}