
import 'package:flutter/material.dart';

import '../../domain/use_cases/user_usecase.dart';

class UserProvider with ChangeNotifier {
  final UserUseCase useCase;
  UserProvider(this.useCase);

}