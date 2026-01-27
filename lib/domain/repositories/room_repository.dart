

import '../entities/room_entity.dart';

abstract class RoomRepository {
  Future<List<RoomEntity>> requestRoomList(String token, String userId);
  Future<void> deleteRoom(String token, String roomId);
  Future<RoomEntity> requestRoomInfoById(int roomId);
}