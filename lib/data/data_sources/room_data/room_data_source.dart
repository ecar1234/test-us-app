

import 'package:test_us_app/data/models/message/room_model.dart';

abstract class RoomDataSource {
  Future<List<RoomModel>> requestRoomList(String token, String userId);
  Future<RoomModel> requestRoomInfoById(int roomId);
}