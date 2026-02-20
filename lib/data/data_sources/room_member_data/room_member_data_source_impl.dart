

import 'package:test_us_app/data/data_sources/room_member_data/room_member_data_source.dart';

import '../../../core/api_names.dart';
import '../../../core/net_driver.dart';
import '../../models/message/room_model.dart';

class RoomMemberDataSourceImpl implements RoomMemberDataSource{
  final NetDriver netDriver;

  RoomMemberDataSourceImpl(this.netDriver);

  @override
  Future<int> deleteRoom(String token, int roomId, String userId) async {
    final res = await netDriver.requestPostJson(token, MessageApi.deleteRoomMember, { "roomId": roomId.toString(), "userId": userId });
    if (res['status'] == 200) {
      if(res['room'] == null){
        return roomId;
      }
      final room = RoomModel.fromJson(res['room']);
      return room.id!;
    } else {
      throw Exception(res['error']);
    }
  }
}