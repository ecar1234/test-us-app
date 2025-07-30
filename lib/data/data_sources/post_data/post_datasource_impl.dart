

import 'package:test_us_app/data/data_sources/post_data/post_datasource.dart';

import '../../../core/net_driver.dart';

class PostDataSourceImpl implements PostDataSource {
  final NetDriver netDriver;
  PostDataSourceImpl(this.netDriver);

}