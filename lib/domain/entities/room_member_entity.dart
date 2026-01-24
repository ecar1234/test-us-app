

import 'package:test_us_app/domain/entities/room_entity.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';

import '../../data/models/message/member_model.dart';

class RoomMemberEntity {
  int? id;
  RoomEntity? room;
  UserEntity? user;
  String? userId;
  int? unreadCount;
  int? lastReadMessageId;
  bool? isActive;
  DateTime? joinedAt;

  RoomMemberEntity({
    this.id,
    this.room,
    this.user,
    this.userId,
    this.unreadCount,
    this.lastReadMessageId,
    this.isActive,
    this.joinedAt,
});

  static RoomMemberEntity toEntity(RoomMemberModel model) {
    final user = UserEntity.toEntity(model.user!);
    final room = RoomEntity.toEntity(model.room!);
    return RoomMemberEntity(
      id: model.id,
      room: room,
      user: user,
      userId: model.userId,
      unreadCount: model.unreadCount,
      lastReadMessageId: model.lastReadMessageId,
      isActive: model.isActive,
      joinedAt: model.joinedAt,
    );
  }
}