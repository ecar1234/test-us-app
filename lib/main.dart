import 'package:flutter/material.dart';
import 'package:test_us_app/domain/use_cases/application_usecase.dart';
import 'package:test_us_app/presentation/main_page.dart';
import 'package:test_us_app/presentation/provider/application_provider.dart';
import 'package:test_us_app/presentation/provider/post_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/service_locator.dart';
import 'package:provider/provider.dart';

import 'domain/use_cases/post_usecase.dart';
import 'domain/use_cases/user_usecase.dart';

Future<void> main() async {
  await serviceLocator();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserProvider(getIt<UserUseCase>())),
      ChangeNotifierProvider(create: (context) => PostProvider(getIt<PostUseCase>())),
      ChangeNotifierProvider(create: (context) => ApplicationProvider(getIt<ApplicationUseCase>())),
    ],
    child: const MetaDataSetting(),
  ));
}
