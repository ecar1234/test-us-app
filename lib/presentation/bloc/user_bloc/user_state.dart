
import 'package:test_us_app/domain/entities/user_entity.dart';

import '../../../domain/entities/user_review_entity.dart';

enum UserDataState {
  serviceStartState,
  userInitDataLoadCompletedState,
  loadingState,
  userInfoUpdateCompletedState,
  getUserDataLoadedState,
  getUsersInfoCompletedState,
  getUsersInfoByEmailCompletedState,
  userDataLoadedState,
  errorState
}

class UserState {
  UserDataState state;
  UserEntity? user;
  List<UserEntity>? users;

  UserState(this.state, {this.user, this.users});
}