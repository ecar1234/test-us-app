import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/presentation/bloc/data_bloc/data_state.dart';

import '../../provider/post_provider.dart';
import '../../provider/user_provider.dart';
import 'data_event.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  Logger logger = Logger();

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
      logger.i("data state : initDataLoadCompletedState");
    });

    on<RequestPostDataEvent>((event, emit) async {
      emit(DataState(state: DataLoadState.dataLoadState));
      event.context.read<PostProvider>().getPostPagination(page: event.page);
      emit(DataState(state: DataLoadState.postDataLoadCompletedState));
      logger.i("data state : postDataLoadCompletedState");
      emit(DataState(state: DataLoadState.beforeDataLoadState));
      logger.i("data state : beforeDataLoadState");
    });

    on<GetPostDetailEvent>((event, emit) async {
      emit(DataState(state: DataLoadState.dataLoadState));
      final res = await event.context.read<PostProvider>().getPostById(event.token, event.postId);
      emit(DataState(state: DataLoadState.getPostByIdCompletedState, post: res));
    });

    on<RequestPostCreateEvent>((event, emit) async {
      emit(DataState(state: DataLoadState.dataLoadState));
      final res = await event.context.read<PostProvider>().createPost(event.token, event.post);
      if (!res) {
        emit(DataState(state: DataLoadState.errorState));
        return;
      }
      emit(DataState(state: DataLoadState.postCreateCompletedState));
    });

    on<RequestPostUpdateEvent>((event, emit) async {
      emit(DataState(state: DataLoadState.dataLoadState));
      final res = await event.context.read<PostProvider>().updatePost(event.token, event.post);
      if (!res) {
        emit(DataState(state: DataLoadState.errorState));
        return;
      }
      emit(DataState(state: DataLoadState.postUpdateCompletedState));
      logger.i("data state : postUpdateCompletedState");
      // emit(DataState(state: DataLoadState.postDataLoadCompletedState));
    });

    on<RequestPostDeleteEvent>((event, emit) async {
      emit(DataState(state: DataLoadState.dataLoadState));
      final res = await event.context.read<PostProvider>().deletePost(event.token, event.postId);
      if (res) {
        emit(DataState(state: DataLoadState.postDeleteCompletedState));
      } else {
        emit(DataState(state: DataLoadState.errorState));
      }
    });

    on<RequestCompleteEvent>((event, emit) {
      emit(DataState(state: DataLoadState.dataLoadState));
      emit(DataState(state: DataLoadState.postDataLoadCompletedState));
      logger.i("data state : postDataLoadCompletedState");
    });

    on<ReloadPostEvent>((event, emit) {
      emit(DataState(state: DataLoadState.postUpdateCompletedState));
    });
  }
}
