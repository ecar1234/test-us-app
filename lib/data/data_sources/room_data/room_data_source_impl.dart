

import 'package:test_us_app/data/data_sources/room_data/room_data_source.dart';
import 'package:test_us_app/data/models/message/room_model.dart';

import '../../../core/api_names.dart';
import '../../../core/net_driver.dart';

class RoomDataSourceImpl implements RoomDataSource {
  final NetDriver netDriver;

  RoomDataSourceImpl(this.netDriver);
  @override
  Future<RoomModel> deleteRoom(String token, String roomId) {
    // TODO: implement deleteRoom
    throw UnimplementedError();
  }

  @override
  Future<List<RoomModel>> requestRoomList(String token, String userId) async {
    final res = await netDriver.requestGetJson(token, MessageApi.requestRoomList, param: userId);
    if (res['status'] == 200) {
      if((res['roomList'] as List<dynamic>).isEmpty){
        return [];
      }
      return res['roomList'].map<RoomModel>((e) => RoomModel.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<RoomModel> requestRoomInfoById(int roomId) async {
    final res = await netDriver.requestGetJson("", MessageApi.requestRoomInfoById, param: roomId.toString());
    if (res['status'] == 200) {
      return RoomModel.fromJson(res['room']);
    } else {
      return RoomModel(id: roomId);
    }
  }

}