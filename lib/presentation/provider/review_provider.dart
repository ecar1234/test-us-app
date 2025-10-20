

import 'package:flutter/cupertino.dart';

import '../../domain/entities/review_entity.dart';
import '../../domain/use_cases/review_usecase.dart';

class ReviewProvider extends ChangeNotifier{
  final ReviewUseCase useCase;
  ReviewProvider(this.useCase);

  // Future<List<ReviewEntity>> getUserReviewAverage(String token, String userId) async {
  //   final res = await useCase.getUserReviewAverage(token, userId);
  //   return res;
  // }

}