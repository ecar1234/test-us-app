

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_us_app/domain/use_cases/promotion_post_usecase.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/promotion_bloc/promotion_event.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/promotion_bloc/promotion_state.dart';

class PromotionBloc extends Bloc<PromotionEvent, PromotionPostState> {
  PromotionBloc(PromotionPostUseCase useCase) : super(PromotionPostState(state:PromotionPostLoadState.serviceStartState)){

  }
}