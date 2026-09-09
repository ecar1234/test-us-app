import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';
import 'package:test_us_app/presentation/bloc/review_bloc/review_event.dart';
import 'package:test_us_app/presentation/bloc/review_bloc/review_state.dart';

import '../../../domain/use_cases/review_usecase.dart';
import '../../../domain/use_cases/user_usecase.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final logger = Logger();

  ReviewBloc(ReviewUseCase useCase, UserUseCase userUseCase) : super(ReviewDataServiceStartState()) {

    on<RequestUserReviewEvent>((event, emit) async {
      emit(ReviewDataLoadingState());
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
        emit(ReviewDataErrorState());
        logger.e('Review State: Error State');
      }
    });

    on<RequestPostReviewEvent>((event, emit) async {
      emit(ReviewDataLoadingState());
      logger.i('Review State: Start Loading');
      try {
        final res = await useCase.getPostReviews(event.token, event.postId);
        if (res.isNotEmpty) {
          final userIds = res.map((e) => e.reviewerUserId!).toList();
          final users = await userUseCase.getUsersByIds(event.token, userIds);

          emit(GetPostReviewState(res, users));
        } else {
          emit(GetPostReviewState([], []));
        }
      } catch(e) {
        emit(ReviewDataErrorState());
        logger.e('Review State: Error State');
      }
    });

    on<RequestTestersReviewEvent>((event, emit) async {
      emit(ReviewDataLoadingState());
      logger.i('Review State: Start Loading');
      try {
        final testers = await userUseCase.getUsersByIds(event.token, event.testerIds);
        final reviews = await useCase.getTestersReviewOnPost(event.token, event.testerIds, event.appId);

        emit(GetTestersReviewDataCompletedState(users: testers, reviews: reviews));
        logger.i('Review State: Get Testers Review Data Completed');
      } catch (e) {
        emit(ReviewDataErrorState());
        logger.e('Review State: Error State');
      }
    });

    on<RequestReviewByPostReviewIdEvent>((event, emit) async {
      emit(ReviewDataLoadingState());
      logger.i('Review State: Start Loading');
      try {
        final res = await useCase.getReviewByPostReviewId(event.token, event.reviewId);
        emit(GetReviewByPostReviewIdCompletedState(res));
        logger.i('Review State: Get Review By Post Review Id Completed');
      } catch(error) {
        emit(ReviewDataErrorState());
        logger.e('Review State: Error State');
      }
    });

    on<RequestReviewByUserReviewIdEvent>((event, emit) async {
      emit(ReviewDataLoadingState());
      logger.i('Review State: Start Loading');
      try {
        final res = await useCase.getReviewByUserReviewId(event.token, event.reviewId);
        emit(GetReviewByUserReviewIdCompletedState(res));
        logger.i('Review State: Get Review By User Review Id Completed');
      } catch(error) {
        emit(ReviewDataErrorState());
        logger.e('Review State: Error State');
      }
    });


    on<CreateUserReviewEvent>((event, emit) async {
      emit(ReviewDataLoadingState());
      logger.i('Review State: Create user Review Loading');
      try {
        final res = await useCase.addTesterReview(event.token, event.review);
        if(res.reviewId == null){
          emit(ReviewDataFailedState());
          return;
        }
        emit(CreateUserReviewCompletedState(res));
        logger.i('Review State: Create User Review Data Completed');
      } catch (e) {
        logger.d(e.toString());
        emit(ReviewDataErrorState());
        logger.e('Review State: Error State');
      }
    });

    on<CreateRecruitPostReviewEvent>((event, emit) async {
      emit(ReviewDataLoadingState());
      logger.i('Review State: Create recruit review Loading');
      try {
        final res = await useCase.addRecruitPostReview(event.token, event.review);
        emit(CreateRecruitPostReviewCompletedState(res));
        logger.i('Review State: Create Recruit Post Review Data Completed');
      } catch (e) {
        emit(ReviewDataErrorState());
        logger.e('Review State: Error State');
      }
    });

    on<CreatePromotionPostReviewEvent>((event, emit) async {
      emit(ReviewDataLoadingState());
      logger.i('Review State: Create promotion review Loading');
      try {
        final res = await useCase.addPromotionPostReview(event.token, event.review);
        emit(CreatePromotionPostReviewCompletedState(res));
        logger.i('Review State: Create Promotion Post Review Data Completed');
      } catch (e) {
        emit(ReviewDataErrorState());
        logger.e('Review State: Error State');
      }
    });

    on<ChangeStateToGetTestersReview>((event, emit)async{

      emit(GetTestersReviewDataCompletedState(users: event.users, reviews: event.reviews));
    });

    on<RequestReviewInitDate>((event, emit) async {
      emit(ReviewDataLoadingState());
      logger.i('Review State: Review init Loading');
      try {
        final initData = await useCase.requestReviewInitData(event.token, event.userId, event.postIds);
        emit(ReviewInitDataCompletedState(initData: initData));
        logger.i('Review State: Review init completed');
      } on Exception catch (e) {
        emit(ReviewDataErrorState());
        logger.e('Review State: Error State');
      }
    });
  }
}
