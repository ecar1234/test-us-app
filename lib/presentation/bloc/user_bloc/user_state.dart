
import 'package:test_us_app/domain/entities/user_entity.dart';

enum UserDataState {
  serviceStartState,
  loadingState,
  getUsersInfoCompletedState,
  userDataLoadedState,
  errorState
}

class UserState {
  UserDataState state;
  UserEntity? user;
  List<UserEntity>? users;
  List<Map<String, dynamic>>? usersAddAverage;
  UserState(this.state, {this.user, this.users, this.usersAddAverage});
}