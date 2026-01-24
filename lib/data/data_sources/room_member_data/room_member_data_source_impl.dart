

import 'package:test_us_app/data/data_sources/room_member_data/room_member_data_source.dart';

import '../../../core/net_driver.dart';

class RoomMemberDataSourceImpl implements RoomMemberDataSource{
  final NetDriver netDriver;

  RoomMemberDataSourceImpl(this.netDriver);
}