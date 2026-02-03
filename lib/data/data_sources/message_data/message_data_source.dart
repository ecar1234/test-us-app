

import '../../models/message/message_model.dart';

abstract class MessageDataSource {
  Future<List<MessageModel>> requestMessageByPostId(String token, String postId, String targetId);
  Future<List<MessageModel>> requestMessageByRoomId(String token, int roomId, String userId);
}