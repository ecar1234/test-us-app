

import 'package:test_us_app/data/data_sources/message_data/message_data_source.dart';
import 'package:test_us_app/domain/entities/message_entity.dart';

import '../../domain/repositories/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageDataSource remote;

  MessageRepositoryImpl(this.remote);

  @override
  Future<List<MessageEntity>> requestMessageByPostId(String token, String postId, String targetId) async {
    final res = await remote.requestMessageByPostId(token, postId, targetId);
    if(res.isEmpty) return [];
    return res.map((e) => MessageEntity.toEntity(e)).toList();
  }

  @override
  Future<List<MessageEntity>> requestMessageByRoomId(String token, int roomId, String userId) async {
    final res = await remote.requestMessageByRoomId(token, roomId, userId);
    if(res.isEmpty) return [];
    return res.map((e) => MessageEntity.toEntity(e)).toList();
  }
}