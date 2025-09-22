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
      try {
        if(event.context.mounted){
          final post = await event.context.read<PostProvider>().createPost(event.token, event.post);
          emit(DataState(state: DataLoadState.postCreateCompletedState, post: post));
        }
      } on Exception catch (e) {
        // TODO
        emit(DataState(state: DataLoadState.errorState));
        logger.e(e);
      }
    });

    on<RequestPostUpdateEvent>((event, emit) async {
      emit(DataState(state: DataLoadState.dataLoadState));
      await event.context.read<PostProvider>().updatePost(event.token, event.post);
      emit(DataState(state: DataLoadState.postUpdateCompletedState, post: event.post));
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
    on<RequestPostImgRegisterEvent>((event, emit) async {
      emit(DataState(state: DataLoadState.dataLoadState));
      final newPost = await event.context.read<PostProvider>().registerPostImg(event.token, event.images!, event.postId);

      emit(DataState(state: DataLoadState.postImgRegisterCompletedState, post: newPost));
      logger.i("data state : postImgRegisterCompletedState");
    });

    on<RequestPostImgUpdateEvent>((event, emit) async {
      emit(DataState(state: DataLoadState.dataLoadState));
      final newPost = await event.context.read<PostProvider>().updatePostImg(event.token, event.deleteImages, event.images!, event.postId);
      emit(DataState(state: DataLoadState.postImgUpdateCompletedState, post: newPost));
      logger.i("data state : postImgUpdateCompletedState");
    });

    on<RequestPostImgDeleteEvent>((event, emit) async {
      emit(DataState(state: DataLoadState.dataLoadState));
      final res = await event.context.read<PostProvider>().deletePostImg(event.token, event.id);
      if(res){
        emit(DataState(state: DataLoadState.postImgDeleteCompletedState));
      }else{
        emit(DataState(state: DataLoadState.errorState));
      }

    });

    on<RequestCompleteEvent>((event, emit) {
      // emit(DataState(state: DataLoadState.dataLoadState));
      emit(DataState(state: DataLoadState.postDataLoadCompletedState));
      logger.i("data state : postDataLoadCompletedState");
    });

    on<ReloadPostEvent>((event, emit) {
      emit(DataState(state: DataLoadState.postUpdateCompletedState));
      logger.i("data state : postDataLoadCompletedState");
    });
  }
}
