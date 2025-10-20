import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/domain/use_cases/post_usecase.dart';
import 'package:test_us_app/presentation/bloc/data_bloc/data_state.dart';

import '../../provider/post_provider.dart';
import '../../provider/user_provider.dart';
import 'data_event.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  Logger logger = Logger();

  DataBloc(PostUseCase postUseCase) : super(DataState(state: DataLoadState.serviceStartState)) {
    on<ServiceStartEvent>((event, emit) {
      emit(DataState(state: DataLoadState.serviceStartState));
      logger.i("data state : serviceStartState");
    });

    on<RequestInitDataEvent>((event, emit) async {
        emit(DataState(state: DataLoadState.initDataLoadCompletedState));
        logger.i("data state : initDataLoadCompletedState");
    });
    //
    on<RequestRecruitmentPaginationEvent>((event, emit) async {
      emit(DataState(state: DataLoadState.postDataLoadCompletedState));
      logger.i("data state : postDataLoadCompletedState");
      // emit(DataState(state: DataLoadState.beforeDataLoadState));
      // logger.i("data state : beforeDataLoadState");
    });
    //
    on<RequestPostDataEvent>((event, emit) async {
      emit(DataState(state: DataLoadState.dataLoadState));
      logger.i("data state : dataLoadState");
      try {
        final result = await postUseCase.getPostById(event.token, event.postId);
        emit(DataState(state: DataLoadState.getPostByIdCompletedState, post: result));
        logger.i("data state : getPostByIdCompletedState");
      } on Exception catch (e) {
        // TODO
        emit(DataState(state: DataLoadState.errorState));
        logger.e("data state : errorState");
      }
    });
    //
    on<RequestPostCreateEvent>((event, emit) async {
      try {
        final result = await postUseCase.createPost(event.token, event.post);
        emit(DataState(state: DataLoadState.postCreateCompletedState, post: result));
        logger.i("data state : postCreateCompletedState");
      } on Exception catch (e) {
        // TODO
        emit(DataState(state: DataLoadState.errorState));
        logger.e("data state : errorState");
      }
    });
    //
    on<RequestPostUpdateEvent>((event, emit) async {
      try {
        final result = await postUseCase.updatePost(event.token, event.post);
        emit(DataState(state: DataLoadState.postUpdateCompletedState, post: result));
        logger.i("data state : postUpdateCompletedState");
      } on Exception catch (e) {
        // TODO
        emit(DataState(state: DataLoadState.errorState));
        logger.e("data state : errorState");
      }
    });
    //
    on<RequestPostDeleteEvent>((event, emit) async {
      emit(DataState(state: DataLoadState.dataLoadState));
      final res = await postUseCase.deletePost(event.token, event.post.id!);
      if(res){
        emit(DataState(state: DataLoadState.postDeleteCompletedState, post: event.post));
        logger.i("data state : postDeleteCompletedState");
      }else {
        emit(DataState(state: DataLoadState.errorState));
        logger.i("data state : errorState");
      }
    });
    //
    on<RequestPostImgRegisterEvent>((event, emit) async {
      final result = await postUseCase.registerPostImg(event.token, event.images, event.postId);
      emit(DataState(state: DataLoadState.postImgRegisterCompletedState, post: result));
      logger.i("data state : postImgRegisterCompletedState");
    });

    on<RequestPostImgUpdateEvent>((event, emit) async {
      final result = await postUseCase.updatePostImg(event.token, event.deleteImages, event.images, event.postId);
      emit(DataState(state: DataLoadState.postImgUpdateCompletedState, post: result));
      logger.i("data state : postImgUpdateCompletedState");
    });
    //
    on<RequestPostImgDeleteEvent>((event, emit) async {
      emit(DataState(state: DataLoadState.dataLoadState));
      final res = await postUseCase.deletePostImg(event.token, event.images);
      if(res){
        emit(DataState(state: DataLoadState.postImgDeleteCompletedState));
        logger.i("data state : postImgDeleteCompletedState");
      }else {
        emit(DataState(state: DataLoadState.errorState));
        logger.i("data state : errorState");
      }
    });
    //
    on<RequestUserRecruitmentPosts>((event, emit) async {
      emit(DataState(state: DataLoadState.dataLoadState));
      logger.i("data state : dataLoadState");
      final res = await postUseCase.getUserRecruitmentPosts(event.token, event.userId);
      emit(DataState(state: DataLoadState.getUserRecruitmentPostsCompletedState, posts: res));
      logger.i("data state : getUserRecruitmentPostsCompletedState");
    });
    //

    on<PostDataLoadEvent>((event, emit) {
      emit(DataState(state: DataLoadState.dataLoadState));
      logger.i("data state : dataLoadState");
    });

    on<RequestCompleteEvent>((event, emit) {
      // emit(DataState(state: DataLoadState.dataLoadState));
      emit(DataState(state: DataLoadState.postDataLoadCompletedState));
      logger.i("data state : postDataLoadCompletedState");
    });
    //
    on<ReloadPostEvent>((event, emit) {
      emit(DataState(state: DataLoadState.postUpdateCompletedState));
      logger.i("data state : postDataLoadCompletedState");
    });
    //
    on<DataLoadErrorEvent>((event, emit) {
      emit(DataState(state: DataLoadState.errorState));
      logger.i("data state : errorState");
    });
  }
}
