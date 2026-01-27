

import 'package:test_us_app/domain/entities/message_entity.dart';
import 'package:test_us_app/domain/entities/recruit_post_entity.dart';
import 'package:test_us_app/domain/entities/room_member_entity.dart';

import '../../data/models/message/room_model.dart';
import 'image_entity.dart';

class RoomPostEntity {
  String? id;
  String? title;
  List<ImageEntity>? images;

  RoomPostEntity(this.id, this.title, this.images);
}
class RoomEntity {
  int? id;
  RoomType? type;
  RoomPostEntity? post;
  String? targetUserId;
  MessageEntity? lastMessage;
  String? lastMessageContent;
  DateTime? lastMessageAt;
  List<RoomMemberEntity>? members;
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
    this.createdAt,
});

  static RoomEntity toEntity(RoomModel model) {
    final post = RoomPostEntity(
      model.post!.id,
      model.post!.title,
      model.post!.images!.map((e) => ImageEntity.toImageEntity(e)).toList(),
    );
    final members = model.members!.map((e) => RoomMemberEntity.toEntity(e)).toList();
    // final messages = model.messages!.map((e) => MessageEntity.toEntity(e)).toList();
    return RoomEntity(
      id: model.id,
      type: model.type,
      post: post,
      targetUserId: model.targetUserId,
      lastMessageContent: model.lastMessageContent,
      lastMessageAt: model.lastMessageAt,
      members: members,
      createdAt: model.createdAt,
    );
  }

  static RoomModel toModel(RoomEntity entity) {
    return RoomModel();
  }
}