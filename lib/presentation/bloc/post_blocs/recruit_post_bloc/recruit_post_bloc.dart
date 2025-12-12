import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/domain/entities/promotion_post_entity.dart';
import 'package:test_us_app/domain/entities/recruit_post_entity.dart';
import 'package:test_us_app/domain/use_cases/recruit_post_usecase.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/recruit_post_bloc/recruit_post_state.dart';

import 'recruit_post_event.dart';

class RecruitPostBloc extends Bloc<RecruitPostEvent, RecruitPostState> {
  Logger logger = Logger();

  RecruitPostBloc(RecruitPostUseCase postUseCase)
      : super(RecruitPostState(state: RecruitPostLoadState.serviceStartState)) {
    // on<ServiceStartEvent>((event, emit) {
    //   emit(RecruitPostState(state: RecruitPostLoadState.serviceStartState));
    //   add(RequestInitDataEvent());
    //   logger.i("data state : serviceStartState");
    // });

    //
    on<RequestRecruitmentPaginationEvent>((event, emit) async {
      try {
        final res = await postUseCase.getPostPagination(event.page, event.size);
        emit(
            RecruitPostState(state: RecruitPostLoadState.recruitPostsLoadCompletedState, posts: res, page: event.page));
        logger.i("data state : recruitPostsLoadCompletedState");
      } on Exception catch (e) {
        // TODO
        emit(RecruitPostState(state: RecruitPostLoadState.errorState));
        logger.e("data state : errorState");
      }
      // emit(DataState(state: RecruitPostLoadState.beforeDataLoadState));
      // logger.i("data state : beforeDataLoadState");
    });
    //
    on<RequestPostDataEvent>((event, emit) async {
      emit(RecruitPostState(state: RecruitPostLoadState.dataLoadState));
      logger.i("data state : dataLoadState");
      try {
        final result = await postUseCase.getPostById(event.token, event.postId);
        emit(RecruitPostState(state: RecruitPostLoadState.getPostByIdCompletedState, post: result));
        logger.i("data state : getPostByIdCompletedState");
      } on Exception catch (e) {
        // TODO
        emit(RecruitPostState(state: RecruitPostLoadState.errorState, post: RecruitPostEntity()));
        logger.e("data state : errorState");
      }
    });
    //
    on<RequestPostCreateEvent>((event, emit) async {
      try {
        emit(RecruitPostState(state: RecruitPostLoadState.dataLoadState));
        logger.i('data state : dataLoadState');
        final result = await postUseCase.createPost(event.token, event.post, event.selectedImages);
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
        emit(RecruitPostState(state: RecruitPostLoadState.dataLoadState));
        logger.i('data state : dataLoadState');
        final result = await postUseCase.updatePost(event.token, event.post, event.selectedImages, event.deletedImages);
        emit(RecruitPostState(state: RecruitPostLoadState.postUpdateCompletedState, post: result));
        logger.i("data state : postUpdateCompletedState");
      } on Exception catch (e) {
        // TODO
        emit(RecruitPostState(state: RecruitPostLoadState.errorState));
        logger.e("data state : errorState");
      }
    });
    //
    on<RequestPostEndEvent>((event, emit) async {
      emit(RecruitPostState(state: RecruitPostLoadState.dataLoadState));
      logger.i('data state : dataLoadState');
      try {
        final res = await postUseCase.endPost(event.token, event.postId);
        emit(RecruitPostState(state: RecruitPostLoadState.postEndCompletedState, post: res));
        logger.i("data state : postEndCompletedState");
      } on Exception catch (e) {
        emit(RecruitPostState(state: RecruitPostLoadState.errorState));
        logger.e("data state : errorState");
      }
    });
    //
    on<RequestPostDeleteEvent>((event, emit) async {
      emit(RecruitPostState(state: RecruitPostLoadState.dataLoadState));
      try {
        logger.i('data state : dataLoadState');
        final res = await postUseCase.deletePost(event.token, event.post.id!);
        if (res == true) {
          emit(RecruitPostState(state: RecruitPostLoadState.postDeleteCompletedState, post: event.post));
        } else {
          emit(RecruitPostState(state: RecruitPostLoadState.failedState));
        }
        logger.i("data state : postDeleteCompletedState");
      } on Exception catch (e) {
        // TODO
        emit(RecruitPostState(state: RecruitPostLoadState.errorState));
        logger.i("data state : errorState");
      }
    });
    //

    on<RequestUserRecruitmentPosts>((event, emit) async {
      try {
        emit(RecruitPostState(state: RecruitPostLoadState.dataLoadState));
        logger.i("data state : dataLoadState");
        final res = await postUseCase.getUserRecruitmentPosts(event.token, event.userId);
        emit(RecruitPostState(state: RecruitPostLoadState.getUserRecruitmentPostsCompletedState, posts: res));
        logger.i("data state : getUserRecruitmentPostsCompletedState");
      } on Exception catch (e) {
        // TODO
        emit(RecruitPostState(state: RecruitPostLoadState.errorState));
        logger.e("data state : errorState");
      }
    });
    //
    on<RequestAppRecruitPosts>((event, emit) async {
      try {
        emit(RecruitPostState(state: RecruitPostLoadState.dataLoadState));
        logger.i("data state : dataLoadState");
        final res = await postUseCase.getAppRecruitPosts(event.token, event.postIds);
        emit(RecruitPostState(state: RecruitPostLoadState.getAppRecruitPostsCompletedState, posts: res));
        logger.i("data state : getAppRecruitPostsCompletedState");
      } on Exception catch (e) {
        // TODO
        emit(RecruitPostState(state: RecruitPostLoadState.errorState));
        logger.e("data state : errorState");
      }
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
