

import '../entities/room_entity.dart';

abstract class RoomMemberRepository {
  Future<int> deleteRoom(String token, int roomId, String userId);
}