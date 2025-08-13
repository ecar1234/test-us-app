enum DataStatus { startService, postsInitCompletedState, getUserDataState, endInitState }

class DataState {
  DataStatus state;
  DataState({this.state = DataStatus.startService});
}
