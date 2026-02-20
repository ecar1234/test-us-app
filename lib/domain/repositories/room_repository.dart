

import '../entities/room_entity.dart';

abstract class RoomRepository {
  Future<List<RoomEntity>> requestRoomList(String token, String userId);
  Future<RoomEntity> requestRoomInfoById(int roomId);
}