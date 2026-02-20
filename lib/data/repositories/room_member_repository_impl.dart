

import '../../domain/entities/room_entity.dart';
import '../../domain/repositories/room_member_repository.dart';
import '../data_sources/room_member_data/room_member_data_source.dart';

class RoomMemberRepositoryImpl implements RoomMemberRepository {
  final RoomMemberDataSource remote;

  RoomMemberRepositoryImpl(this.remote);

  @override
  Future<int> deleteRoom(String token, int roomId, String userId) async {
    final res = await remote.deleteRoom(token, roomId, userId);
    return res;
  }
}