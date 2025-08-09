enum DataStatus { startService, getIntiDataState, endInitState }

class DataState {
  DataStatus state;

  DataState({this.state = DataStatus.startService});
}
