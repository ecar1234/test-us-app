

import '../../models/message/room_model.dart';

abstract class RoomMemberDataSource {
  Future<int> deleteRoom(String token, int roomId, String userId);
}