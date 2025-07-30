

import 'package:test_us_app/domain/repositories/application_repo.dart';

import '../data_sources/application_data/application_datasource.dart';

class ApplicationRepositoryImpl implements ApplicationRepository {
  final ApplicationDataSource remote;
  ApplicationRepositoryImpl(this.remote);

}