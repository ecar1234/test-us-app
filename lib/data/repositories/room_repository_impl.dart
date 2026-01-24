

import 'package:test_us_app/domain/entities/room_entity.dart';

import '../../domain/repositories/room_repository.dart';
import '../data_sources/room_data/room_data_source.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomDataSource remote;

  RoomRepositoryImpl(this.remote);

  @override
  Future<void> deleteRoom(String token, String roomId) {
    // TODO: implement deleteRoom
    throw UnimplementedError();
  }

  @override
  Future<List<RoomEntity>> requestRoomList(String token, String userId) async {
    final res = await remote.requestRoomList(token, userId);
    if(res.isEmpty) return [];
    return res.map((e) => RoomEntity.toEntity(e)).toList();
  }

}