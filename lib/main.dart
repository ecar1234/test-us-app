import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_us_app/domain/use_cases/application_usecase.dart';
import 'package:test_us_app/presentation/bloc/app_bloc/app_bloc.dart';
import 'package:test_us_app/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:test_us_app/presentation/bloc/data_bloc/data_bloc.dart';
import 'package:test_us_app/presentation/bloc/review_bloc/review_bloc.dart';
import 'package:test_us_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:test_us_app/presentation/main_page.dart';
import 'package:test_us_app/presentation/provider/application_provider.dart';
import 'package:test_us_app/presentation/provider/post_provider.dart';
import 'package:test_us_app/presentation/provider/review_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/service_locator.dart';
import 'package:provider/provider.dart';

import 'domain/use_cases/post_usecase.dart';
import 'domain/use_cases/review_usecase.dart';
import 'domain/use_cases/user_usecase.dart';

Future<void> main() async {
  await serviceLocator();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserProvider(getIt<UserUseCase>())),
      ChangeNotifierProvider(create: (context) => PostProvider(getIt<PostUseCase>())),
      ChangeNotifierProvider(create: (context) => ApplicationProvider(getIt<ApplicationUseCase>())),
      ChangeNotifierProvider(create: (context) => ReviewProvider(getIt<ReviewUseCase>())),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(getIt<UserUseCase>())),
        BlocProvider(create: (context) => UserBloc(getIt<UserUseCase>())),
        BlocProvider(create: (context) => DataBloc(getIt<PostUseCase>())),
        BlocProvider(create: (context) => AppBloc(getIt<ApplicationUseCase>(), getIt<PostUseCase>())),
        BlocProvider(create: (context) => ReviewBloc(getIt<ReviewUseCase>())),
      ], child: const MetaDataSetting(),
    ),
  ));
}
