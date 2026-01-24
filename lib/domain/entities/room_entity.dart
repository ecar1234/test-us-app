

import 'package:test_us_app/domain/entities/message_entity.dart';
import 'package:test_us_app/domain/entities/recruit_post_entity.dart';
import 'package:test_us_app/domain/entities/room_member_entity.dart';

import '../../data/models/message/room_model.dart';

class RoomEntity {
  int? id;
  RoomType? type;
  RecruitPostEntity? post;
  String? targetUserId;
  MessageEntity? lastMessage;
  String? lastMessageContent;
  DateTime? lastMessageAt;
  List<RoomMemberEntity>? members;
  List<MessageEntity>? messages;
  DateTime? createdAt;

  RoomEntity ({
    this.id,
    this.type,
    this.post,
    this.targetUserId,
    this.lastMessage,
    this.lastMessageContent,
    this.lastMessageAt,
    this.members,
    this.messages,
    this.createdAt,
});

  static RoomEntity toEntity(RoomModel model) {
    final post = RecruitPostEntity.toPostEntity(model.post!);
    final members = model.members!.map((e) => RoomMemberEntity.toEntity(e)).toList();
    final messages = model.messages!.map((e) => MessageEntity.toEntity(e)).toList();
    return RoomEntity(
      id: model.id,
      type: model.type,
      post: post,
      targetUserId: model.targetUserId,
      lastMessage: MessageEntity.toEntity(model.lastMessage!),
      lastMessageContent: model.lastMessageContent,
      lastMessageAt: model.lastMessageAt,
      members: members,
      messages: messages,
      createdAt: model.createdAt,
    );
  }

  static RoomModel toModel(RoomEntity entity) {
    return RoomModel();
  }
}