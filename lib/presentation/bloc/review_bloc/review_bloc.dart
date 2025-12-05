import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/presentation/bloc/review_bloc/review_event.dart';
import 'package:test_us_app/presentation/bloc/review_bloc/review_state.dart';

import '../../../domain/use_cases/review_usecase.dart';
import '../../../domain/use_cases/user_usecase.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final logger = Logger();

  ReviewBloc(ReviewUseCase useCase, UserUseCase userUseCase) : super(ReviewState(ReviewDataState.serviceStartState)) {
    on<RequestUserReviewEvent>((event, emit) async {
      emit(ReviewState(ReviewDataState.loadingState));
      logger.i('Review State: Start Loading');
      try {
        final res = await useCase.getReviews(event.token, event.userId);
        if (res.isNotEmpty) {
          double sum = 0;
          for (var review in res) {
            if(review.rating != null){
              sum += review.rating!;
            }
          }
          double avg = sum / res.length;
          emit(GetUserReviewDataCompletedState(res, avg));
        } else {
          emit(GetUserReviewDataCompletedState(res, 0.0));
        }
        logger.i('Review State: Get User Review Data Completed');
      } catch (e) {
        emit(ReviewState(ReviewDataState.errorState));
        logger.e('Review State: Error State');
      }
    });

    on<RequestPostReviewEvent>((event, emit) async {
      emit(ReviewState(ReviewDataState.loadingState));
      logger.i('Review State: Start Loading');
      try {
        final res = await useCase.getPostReviews(event.token, event.postId);
        if (res.isNotEmpty) {
          double sum = 0;
          for (int i = 0; i < res.length; i++) {
            sum += res[i].rating!;
          }
          double avg = sum / res.length;
          emit(GetPostReviewState(res, avg));
        } else {
          emit(GetPostReviewState(res, 0.0));
        }
      } catch(e) {
        emit(ReviewState(ReviewDataState.errorState));
        logger.e('Review State: Error State');
      }
    });

    on<RequestTestersReviewEvent>((event, emit) async {
      emit(ReviewState(ReviewDataState.loadingState));
      logger.i('Review State: Start Loading');
      try {
        final testers = await userUseCase.getUsersByIds(event.token, event.testerIds);
        final reviews = await useCase.getTestersReviewOnPost(event.token, event.testerIds, event.appId);

        emit(GetTestersReviewDataCompletedState(users: testers, reviews: reviews));
        logger.i('Review State: Get Testers Review Data Completed');
      } catch (e) {
        emit(ReviewState(ReviewDataState.errorState));
        logger.e('Review State: Error State');
      }
    });

    on<CreateUserReviewEvent>((event, emit) async {
      emit(ReviewState(ReviewDataState.loadingState));
      logger.i('Review State: Start Loading');
      try {
        final res = await useCase.addTesterReview(event.token, event.review);
        if(res.reviewId == null){
          emit(ReviewState(ReviewDataState.failedState));
          return;
        }
        emit(CreateUserReviewCompletedState(res));
        logger.i('Review State: Create User Review Data Completed');
      } catch (e) {
        logger.d(e.toString());
        emit(ReviewState(ReviewDataState.errorState));
        logger.e('Review State: Error State');
      }
    });

    on<CreateRecruitPostReviewEvent>((event, emit) async {
      emit(ReviewState(ReviewDataState.loadingState));
      logger.i('Review State: Start Loading');
      try {
        final res = await useCase.addRecruitPostReview(event.token, event.review);
        emit(CreateRecruitPostReviewCompletedState(res));
        logger.i('Review State: Create Recruit Post Review Data Completed');
      } catch (e) {
        emit(ReviewState(ReviewDataState.errorState));
        logger.e('Review State: Error State');
      }
    });

    on<CreatePromotionPostReviewEvent>((event, emit) async {
      emit(ReviewState(ReviewDataState.loadingState));
      logger.i('Review State: Start Loading');
      try {
        final res = await useCase.addPromotionPostReview(event.token, event.review);
        emit(CreatePromotionPostReviewCompletedState(res));
        logger.i('Review State: Create Promotion Post Review Data Completed');
      } catch (e) {
        emit(ReviewState(ReviewDataState.errorState));
        logger.e('Review State: Error State');
      }
    });

    on<ChangeStateToGetTestersReview>((event, emit)async{

      emit(GetTestersReviewDataCompletedState(users: event.users, reviews: event.reviews));
    });
  }
}
