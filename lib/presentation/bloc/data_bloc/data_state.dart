

enum DataLoadState {
  serviceStartState,
  beforeDataLoadState,
  dataLoadState,
  userDataLoadState,
  initDataLoadCompletedState,
  postDataLoadCompletedState,
}

class DataState {
  DataLoadState state;
  DataState({this.state = DataLoadState.serviceStartState});
}
