enum DataLoadState { serviceStartState, dataLoadState, userDataLoadState, initDataLoadCompletedState, webDataLoadCompletedState, mobileDataLoadCompletedState }

class DataState {
  DataLoadState state;
  DataState({this.state = DataLoadState.serviceStartState});
}
