
import 'package:flutter/material.dart';

import '../../domain/use_cases/application_usecase.dart';

class ApplicationProvider with ChangeNotifier{
  final ApplicationUseCase useCase;
  ApplicationProvider(this.useCase);

}