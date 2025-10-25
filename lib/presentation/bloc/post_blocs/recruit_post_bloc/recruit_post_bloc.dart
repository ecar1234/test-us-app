import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/domain/use_cases/recruit_post_usecase.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/recruit_post_bloc/recruit_post_state.dart';

import 'recruit_post_event.dart';

class RecruitPostBloc extends Bloc<RecruitPostEvent, RecruitPostState> {
  Logger logger = Logger();

  RecruitPostBloc(RecruitPostUseCase postUseCase) : super(RecruitPostState(state: RecruitPostLoadState.serviceStartState)) {
    on<ServiceStartEvent>((event, emit) {
      emit(RecruitPostState(state: RecruitPostLoadState.serviceStartState));
      logger.i("data state : serviceStartState");
    });

    on<RequestInitDataEvent>((event, emit) async {
        emit(RecruitPostState(state: RecruitPostLoadState.initDataLoadCompletedState));
        logger.i("data state : initDataLoadCompletedState");
    });
    //
    on<RequestRecruitmentPaginationEvent>((event, emit) async {
      emit(RecruitPostState(state: RecruitPostLoadState.postDataLoadCompletedState));
      logger.i("data state : postDataLoadCompletedState");
      // emit(DataState(state: RecruitPostLoadState.beforeDataLoadState));
      // logger.i("data state : beforeDataLoadState");
    });
    //
    on<RequestPostDataEvent>((event, emit) async {
      emit(RecruitPostState(state: RecruitPostLoadState.dataLoadState));
      logger.i("data state : RecruitPostLoadState");
      try {
        final result = await postUseCase.getPostById(event.token, event.postId);
        emit(RecruitPostState(state: RecruitPostLoadState.getPostByIdCompletedState, post: result));
        logger.i("data state : getPostByIdCompletedState");
      } on Exception catch (e) {
        // TODO
        emit(RecruitPostState(state: RecruitPostLoadState.errorState));
        logger.e("data state : errorState");
      }
    });
    //
    on<RequestPostCreateEvent>((event, emit) async {
      try {
        final result = await postUseCase.createPost(event.token, event.post);
        emit(RecruitPostState(state: RecruitPostLoadState.postCreateCompletedState, post: result));
        logger.i("data state : postCreateCompletedState");
      } on Exception catch (e) {
        // TODO
        emit(RecruitPostState(state: RecruitPostLoadState.errorState));
        logger.e("data state : errorState");
      }
    });
    //
    on<RequestPostUpdateEvent>((event, emit) async {
      try {
        final result = await postUseCase.updatePost(event.token, event.post);
        emit(RecruitPostState(state: RecruitPostLoadState.postUpdateCompletedState, post: result));
        logger.i("data state : postUpdateCompletedState");
      } on Exception catch (e) {
        // TODO
        emit(RecruitPostState(state: RecruitPostLoadState.errorState));
        logger.e("data state : errorState");
      }
    });
    //
    on<RequestPostDeleteEvent>((event, emit) async {
      emit(RecruitPostState(state: RecruitPostLoadState.dataLoadState));
      final res = await postUseCase.deletePost(event.token, event.post.id!);
      if(res){
        emit(RecruitPostState(state: RecruitPostLoadState.postDeleteCompletedState, post: event.post));
        logger.i("data state : postDeleteCompletedState");
      }else {
        emit(RecruitPostState(state: RecruitPostLoadState.errorState));
        logger.i("data state : errorState");
      }
    });
    //

    on<RequestUserRecruitmentPosts>((event, emit) async {
      emit(RecruitPostState(state: RecruitPostLoadState.dataLoadState));
      logger.i("data state : dataLoadState");
      final res = await postUseCase.getUserRecruitmentPosts(event.token, event.userId);
      emit(RecruitPostState(state: RecruitPostLoadState.getUserRecruitmentPostsCompletedState, posts: res));
      logger.i("data state : getUserRecruitmentPostsCompletedState");
    });
    //

    on<PostDataLoadEvent>((event, emit) {
      emit(RecruitPostState(state: RecruitPostLoadState.dataLoadState));
      logger.i("data state : dataLoadState");
    });

    on<RequestCompleteEvent>((event, emit) {
      // emit(DataState(state: DataLoadState.dataLoadState));
      emit(RecruitPostState(state: RecruitPostLoadState.postDataLoadCompletedState));
      logger.i("data state : postDataLoadCompletedState");
    });
    //
    on<ReloadPostEvent>((event, emit) {
      emit(RecruitPostState(state: RecruitPostLoadState.postUpdateCompletedState));
      logger.i("data state : postDataLoadCompletedState");
    });
    //
    on<DataLoadErrorEvent>((event, emit) {
      emit(RecruitPostState(state: RecruitPostLoadState.errorState));
      logger.i("data state : errorState");
    });
  }
}
