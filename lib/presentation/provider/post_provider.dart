

import 'package:flutter/material.dart';

import '../../domain/use_cases/post_usecase.dart';

class PostProvider with ChangeNotifier{
  final PostUseCase useCase;
  PostProvider(this.useCase);
}