

import '../../domain/repositories/user_repository.dart';
import '../data_sources/user_data/user_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource remote;

  UserRepositoryImpl(this.remote);


}