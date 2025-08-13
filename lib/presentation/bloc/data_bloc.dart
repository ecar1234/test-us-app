import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_us_app/presentation/bloc/data_state.dart';

import '../provider/post_provider.dart';
import '../provider/user_provider.dart';
import 'data_event.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc() : super (DataState(state: DataStatus.startService)){
    on<RequestUserInfoEvent>((event, emit) async {
      // event.context.read<UserProvider>().;
      emit(DataState(state: DataStatus.getUserDataState));
    });

    on<RequestPostDataEvent>((event, emit) async {
      event.context.read<PostProvider>().getPosts();
      emit(DataState(state: DataStatus.postsInitCompletedState));
    });

  }
}