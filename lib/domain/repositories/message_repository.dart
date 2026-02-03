

import '../entities/message_entity.dart';

abstract class MessageRepository {
  Future<List<MessageEntity>> requestMessageByPostId(String token, String postId, String targetId);
  Future<List<MessageEntity>> requestMessageByRoomId(String token, int roomId, String userId);
}