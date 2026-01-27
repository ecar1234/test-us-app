

import 'package:test_us_app/domain/entities/user_entity.dart';

import '../../data/models/message/message_model.dart';
import '../../data/models/package/recruit_post_applications_model.dart';

class MessageEntity {
  int? id;
  String? content;
  User? sender;
  int? roomId;
  DateTime? createdAt;


  MessageEntity({
    this.id,
    this.content,
    this.sender,
    this.roomId,
    this.createdAt
  });

  static MessageEntity toEntity(MessageModel model) {
    final sender = User(
      userId: model.sender!.userId,
      nickname: model.sender!.nickname,
      email: model.sender!.email,
    );
    return MessageEntity(
      id: model.id,
      content: model.content,
      sender: sender,
      roomId: model.roomId,
      createdAt: model.createdAt,
    );
  }
}
