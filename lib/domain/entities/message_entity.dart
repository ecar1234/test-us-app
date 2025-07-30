

class MessageEntity {
  String? messageId;
  String? message;
  String? sender;
  String? receiver;
  bool? deleteSender;
  bool? deleteReceiver;
  DateTime? createdAt;
  DateTime? readAt;

  MessageEntity({
    this.messageId,
    this.message,
    this.sender,
    this.receiver,
    this.deleteSender,
    this.deleteReceiver,
    this.createdAt,
    this.readAt,
  });
}
