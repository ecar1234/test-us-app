

import 'package:test_us_app/domain/entities/room_entity.dart';

import '../entities/message_entity.dart';

abstract class MessageRepository {
  Future<List<MessageEntity>> requestMessageByPostId(String token, String postId, String targetId);
  Future<List<MessageEntity>> requestMessageByRoomId(String token, int roomId, String userId);
  Future<RoomEntity> resetUnreadCount(String token, int roomId, String userId);
}