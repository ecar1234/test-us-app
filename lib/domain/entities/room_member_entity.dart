

import 'package:test_us_app/domain/entities/room_entity.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';

import '../../data/models/message/member_model.dart';

class RoomMemberEntity {
  int? id;
  int? roomId;
  UserEntity? user;
  int? unreadCount;
  int? lastReadMessageId;
  bool? isActive;
  DateTime? joinedAt;

  RoomMemberEntity({
    this.id,
    this.roomId,
    this.user,
    this.unreadCount,
    this.lastReadMessageId,
    this.isActive,
    this.joinedAt,
});

  static RoomMemberEntity toEntity(RoomMemberModel model) {
    final user = UserEntity.toEntity(model.user!);
    return RoomMemberEntity(
      id: model.id,
      roomId: model.roomId,
      user: user,
      unreadCount: model.unreadCount,
      lastReadMessageId: model.lastReadMessageId,
      isActive: model.isActive,
      joinedAt: model.joinedAt,
    );
  }
}