

import 'package:test_us_app/domain/entities/room_entity.dart';

import '../repositories/message_repository.dart';
import '../repositories/room_member_repository.dart';
import '../repositories/room_repository.dart';

class MessageUseCase {
  final RoomRepository _roomRepo;
  final MessageRepository _messageRepo;
  final RoomMemberRepository _roomMemberRepo;


  MessageUseCase(this._roomRepo, this._messageRepo, this._roomMemberRepo);

  Future<List<RoomEntity>> requestRoomList(String token, String userId) async {
    final res = await _roomRepo.requestRoomList(token, userId);
    return res;
  }
}