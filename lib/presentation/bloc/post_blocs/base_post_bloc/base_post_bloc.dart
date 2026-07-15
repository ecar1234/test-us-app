

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/domain/use_cases/base_post_usecase.dart';

import '../../../../domain/entities/promotion_post_entity.dart';
import '../../../../domain/entities/recruit_post_entity.dart';
import '../../../../domain/use_cases/recruit_post_usecase.dart';
import 'base_post_event.dart';
import 'base_post_state.dart';

class BasePostBloc extends Bloc<BasePostEvent, BasePostState>{
  final logger = Logger();
  BasePostBloc(BasePostUseCase postUseCase) : super(BasePostState(BasePostLoadState.initialState)){

    on<ServiceStartEvent>((event, emit){
      emit(BasePostState(BasePostLoadState.serviceStartState));
      logger.i("data state : serviceStartState");
      add(RequestInitDataEvent());
    });

    on<RequestInitDataEvent>((event, emit) async {
      try {
        emit(BasePostState(BasePostLoadState.initPostDataLoadingState));
        logger.i("data state : dataLoadState");
        final res = await postUseCase.getPostInitData();
        final List<dynamic> favoritePosts = res['favoritePosts'];
        final List<RecruitPostEntity> recruitPosts = res['recruitPosts'];
        final List<PromotionPostEntity> promotionPosts = res['promotionPosts'];
        emit(BasePostState(BasePostLoadState.getInitPostCompletedState, recruitPosts: recruitPosts, promotionPosts: promotionPosts, favoritePosts: favoritePosts));
        logger.i("data state : initDataLoadCompletedState");
      } on Exception catch (e) {
        emit(BasePostState(BasePostLoadState.errorState));
        logger.e("data state : errorState");
      }
    });

    on<RequestUserInItDataEvent>((event, emit) async {
      emit(BasePostState(BasePostLoadState.dataLoadState));
      try {
        final res = await postUseCase.getUserInitData(event.token, event.userId);
        emit(BasePostState(BasePostLoadState.getUserInitPostsCompletedState, initData: res));
      } catch (e) {
        emit(BasePostState(BasePostLoadState.errorState));
        logger.e(e);
      }
    });

    on<SearchPostEvent>((event, emit) async {
      emit(BasePostState(BasePostLoadState.dataLoadState));
      logger.i("data state : dataLoadState");
      try {
        final res = await postUseCase.searchPost(event.keyword);
        emit(GetSearchPostState(BasePostLoadState.searchPostCompletedState, recruit: res['recruitPosts'], promotion: res['promotionPosts']));
      }
      catch (e) {
        emit(BasePostState(BasePostLoadState.errorState));
        logger.e("data state : errorState");
      }
    });

  }
}