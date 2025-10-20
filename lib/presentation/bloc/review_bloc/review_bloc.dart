

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/presentation/bloc/review_bloc/review_event.dart';
import 'package:test_us_app/presentation/bloc/review_bloc/review_state.dart';

import '../../../domain/use_cases/review_usecase.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState>{
  final logger = Logger();
  ReviewBloc(ReviewUseCase userUseCase): super(ReviewState(ReviewDataState.serviceStartState)){
    on<RequestUserReviewEvent>((event, emit) async {
      emit(ReviewState(ReviewDataState.loadingState));
      logger.i('ReviewBlocState: RequestUserReviewEvent');
      try {
        final review = await userUseCase.getUserReview(event.token, event.userId);
        emit(ReviewState(ReviewDataState.getUserReviewCompletedState, review: review));
        logger.i('ReviewBlocState: getUserReviewCompletedState');
      } catch (e) {
        emit(ReviewState(ReviewDataState.errorState));
        logger.i('ReviewBlocState: errorState');
      }
    });

    on<RequestUsersReviewEvent>((event, emit) async {
      emit(ReviewState(ReviewDataState.loadingState));
      logger.i('ReviewBlocState: RequestUsersReviewEvent');
      try {
        final review = await userUseCase.getUsersReview(event.token, event.userIds);
        emit(ReviewState(ReviewDataState.getUserReviewAverageCompletedState, reviewAverages: review));
        logger.i('ReviewBlocState: getReviewAverageCompletedState');
      } catch (e) {
        emit(ReviewState(ReviewDataState.errorState));
        logger.i('ReviewBlocState: errorState');
      }
    });
  }
}