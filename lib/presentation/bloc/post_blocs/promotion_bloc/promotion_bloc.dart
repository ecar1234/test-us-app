

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/promotion_bloc/promotion_event.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/promotion_bloc/promotion_state.dart';

class PromotionBloc extends Bloc<PromotionEvent, PromotionPostState> {
  PromotionBloc() : super(PromotionPostState(state:PromotionPostLoadState.serviceStartState)){

  }
}