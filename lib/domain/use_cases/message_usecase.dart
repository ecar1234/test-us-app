

import 'package:test_us_app/domain/entities/room_entity.dart';

import '../entities/message_entity.dart';
import '../repositories/message_repository.dart';
import '../repositories/room_member_repository.dart';
import '../repositories/room_repository.dart';

class MessageUseCase {
  final RoomRepository _roomRepo;
  final MessageRepository _messageRepo;
  final RoomMemberRepository _roomMemberRepo;


  MessageUseCase(this._roomRepo, this._messageRepo, this._roomMemberRepo);

  // room
  Future<List<RoomEntity>> requestRoomList(String token, String userId) async {
    final res = await _roomRepo.requestRoomList(token, userId);
    return res;
  }

  Future<RoomEntity> requestRoomInfoById(int roomId) async {
    final res = await _roomRepo.requestRoomInfoById(roomId);
    return res;
  }

  // message
  Future<List<MessageEntity>> requestMessageByPostId(String token, String postId, String targetId) async {
    final res = await _messageRepo.requestMessageByPostId(token, postId, targetId);
    return res;
  }
  Future<List<MessageEntity>> requestMessageByRoomId(String token, int roomId) async {
    final res = await _messageRepo.requestMessageByRoomId(token, roomId);
    return res;
  }
}