import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/domain/use_cases/promotion_post_usecase.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/promotion_bloc/promotion_event.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/promotion_bloc/promotion_state.dart';

import '../../../../domain/entities/promotion_post_entity.dart';

class PromotionBloc extends Bloc<PromotionEvent, PromotionPostState> {
  final logger = Logger();
  PromotionBloc(PromotionPostUseCase useCase)
      : super(PromotionPostState(state: PromotionPostLoadState.serviceStartState)) {

    on<RequestPostCreateEvent>((event, emit) async {
      try {
        emit(PromotionPostState(state: PromotionPostLoadState.postLoadingState));
        logger.i('data state : postLoadingState');
        final res = await useCase.createPost(event.token, event.post, event.selectedImages);
        emit(PromotionPostState(state: PromotionPostLoadState.postCreateCompletedState, post: res));
        logger.i('data state : postCreateCompletedState');
      } on Exception catch (e) {
        // TODO
        emit(PromotionPostState(state: PromotionPostLoadState.errorState));
        logger.e('error: $e');
      }
    });

    on<RequestPostUpdateEvent>((event, emit) async {
      try {
        emit(PromotionPostState(state: PromotionPostLoadState.postLoadingState));
        logger.i('data state : postLoadingState');
        final res = await useCase.updatePost(event.token, event.post, event.selectedImages, event.deletedImages);
        emit(PromotionPostState(state: PromotionPostLoadState.postUpdateCompletedState, post: res));
        logger.i('data state : postUpdateCompletedState');
      } on Exception catch (e) {
        // TODO
        emit(PromotionPostState(state: PromotionPostLoadState.errorState));
        logger.e('error: $e');
      }
    });

    on<RequestPostDeleteEvent>((event, emit) async {
      try {
        emit(PromotionPostState(state: PromotionPostLoadState.postLoadingState));
        logger.i('data state : postLoadingState');
        final res = await useCase.deletePost(event.token, event.postId);
        if(res) {
          emit(PromotionPostState(state: PromotionPostLoadState.postDeleteCompletedState, postId: event.postId));
          logger.i('data state : postDeleteCompletedState');
        }else {
          emit(PromotionPostState(state: PromotionPostLoadState.failedState));
          logger.i('data state : failedState');
        }
      } on Exception catch (e) {
        // TODO
        emit(PromotionPostState(state: PromotionPostLoadState.errorState));
        logger.e('error: $e');
      }
    });

    on<RequestPromotionPostDataEvent>((event, emit) async {
      try {
        emit(PromotionPostState(state: PromotionPostLoadState.postLoadingState));
        logger.i('data state : postLoadingState');
        final res = await useCase.getPromotionPostById(event.token, event.postId);
        emit(PromotionPostState(state: PromotionPostLoadState.getPostByIdCompletedState, post: res));
        logger.i('data state : getPostByIdCompletedState');
      } on Exception catch (e) {
        // TODO
        emit(PromotionPostState(state: PromotionPostLoadState.errorState));
        logger.e('error: $e');
      }
    });

    on<RequestPromotionPaginationEvent>((event, emit) async {
      try {
        final res = await useCase.getPostPagination(event.page, event.size);
        emit(PromotionPaginationState(resPosts: res.posts!, page: res.page ?? 0, isLast: res.isLast ?? true));
        logger.i("data state : recruitPostsLoadCompletedState");
      } on Exception catch (e) {
        // TODO
        emit(PromotionPostState(state: PromotionPostLoadState.errorState));
        logger.e("data state : errorState");
      }
      // emit(DataState(state: RecruitPostLoadState.beforeDataLoadState));
      // logger.i("data state : beforeDataLoadState");
    });
  }
}
