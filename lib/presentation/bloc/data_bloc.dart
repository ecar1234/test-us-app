import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_us_app/presentation/bloc/data_state.dart';

import '../provider/post_provider.dart';
import '../provider/user_provider.dart';
import 'data_event.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc() : super(DataState(state: DataLoadState.serviceStartState)) {
    // on<RequestUserInfoEvent>((event, emit) async {
    //   emit(DataState(state: DataLoadState.dataLoadState));
    //   event.context.read<UserProvider>().;
    //
    // });
    on<RequestInitDataEvent>((event, emit) {
      emit(DataState(state: DataLoadState.dataLoadState));
      event.context.read<PostProvider>().getInitPosts();
      emit(DataState(state: DataLoadState.initDataLoadCompletedState));
    });

    on<RequestPostDataEvent>((event, emit) async {
      emit(DataState(state: DataLoadState.dataLoadState));
      if (event.platform == 'web') {
        event.context.read<PostProvider>().getWebPosts(page: event.page);
        emit(DataState(state: DataLoadState.webDataLoadCompletedState));
      } else {
        event.context.read<PostProvider>().getMobilePosts(page: event.page);
        emit(DataState(state: DataLoadState.mobileDataLoadCompletedState));
      }
    });
  }
}
