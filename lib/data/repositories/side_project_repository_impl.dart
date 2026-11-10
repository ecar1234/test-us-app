
import 'package:test_us_app/data/data_sources/post_data/side_project_datasource.dart';
import 'package:test_us_app/domain/repositories/side_project_repo.dart';

class SideProjectRepositoryImpl implements SideProjectRepo{
  final SideProjectDatasource remote;
  SideProjectRepositoryImpl(this.remote);
}