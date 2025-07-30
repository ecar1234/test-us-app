

import 'package:test_us_app/data/data_sources/user_data/user_data_source.dart';

import '../../../core/net_driver.dart';

class UserDataSourceImpl implements UserDataSource {
  final NetDriver netDriver;
  UserDataSourceImpl(this.netDriver);
}