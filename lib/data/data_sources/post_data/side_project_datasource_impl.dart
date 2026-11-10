
import 'package:test_us_app/core/net_driver.dart';
import 'package:test_us_app/data/data_sources/post_data/side_project_datasource.dart';

class SideProjectDatasourceImpl implements SideProjectDatasource{
  final NetDriver netDriver;
  SideProjectDatasourceImpl(this.netDriver);
}