

import '../../domain/repositories/room_member_repository.dart';
import '../data_sources/room_member_data/room_member_data_source.dart';

class RoomMemberRepositoryImpl implements RoomMemberRepository {
  final RoomMemberDataSource remote;

  RoomMemberRepositoryImpl(this.remote);
}