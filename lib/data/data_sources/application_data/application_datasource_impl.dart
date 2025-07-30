

import 'package:test_us_app/core/net_driver.dart';

import 'application_datasource.dart';

class ApplicationDataSourceImpl implements ApplicationDataSource {
  final NetDriver netDriver;
  ApplicationDataSourceImpl(this.netDriver);
}