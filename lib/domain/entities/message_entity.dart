

import 'package:test_us_app/domain/entities/user_entity.dart';

import '../../data/models/message/message_model.dart';

class MessageEntity {
  String? id;
  String? message;
  UserEntity? sender;
  String? receiver;
  bool? deleteSender;
  bool? deleteReceiver;
  DateTime? createdAt;

  MessageEntity({
    this.id,
    this.message,
    this.sender,
    this.receiver,
    this.deleteSender,
    this.deleteReceiver,
    this.createdAt,
  });

  static MessageEntity toEntity(MessageModel model) {
    final sender = UserEntity.toEntity(model.sender!);
    return MessageEntity(
      id: model.id,
      message: model.content,
      sender: sender,
      receiver: model.receiver,
      deleteSender: model.deleteSender,
      deleteReceiver: model.deleteReceiver,
      createdAt: model.createdAt,
    );
  }
}
