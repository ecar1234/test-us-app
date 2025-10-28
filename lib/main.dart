import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_us_app/domain/use_cases/application_usecase.dart';
import 'package:test_us_app/domain/use_cases/image_usecase.dart';
import 'package:test_us_app/domain/use_cases/promotion_post_usecase.dart';
import 'package:test_us_app/presentation/bloc/app_bloc/app_bloc.dart';
import 'package:test_us_app/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:test_us_app/presentation/bloc/image_bloc/image_bloc.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/recruit_post_bloc/recruit_post_bloc.dart';
import 'package:test_us_app/presentation/bloc/review_bloc/review_bloc.dart';
import 'package:test_us_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:test_us_app/presentation/main_page.dart';
import 'package:test_us_app/presentation/provider/application_provider.dart';
import 'package:test_us_app/presentation/provider/post_provider/favorite_post_provider.dart';
import 'package:test_us_app/presentation/provider/post_provider/promotion_post_provider.dart';
import 'package:test_us_app/presentation/provider/post_provider/recruit_post_provider.dart';
import 'package:test_us_app/presentation/provider/review_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/service_locator.dart';
import 'package:provider/provider.dart';

import 'domain/use_cases/recruit_post_usecase.dart';
import 'domain/use_cases/review_usecase.dart';
import 'domain/use_cases/user_usecase.dart';

Future<void> main() async {
  await serviceLocator();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserProvider(getIt<UserUseCase>())),
      ChangeNotifierProvider(create: (context) => FavoritePostProvider()),
      ChangeNotifierProvider(create: (context) => RecruitPostProvider(getIt<RecruitPostUseCase>())),
      ChangeNotifierProvider(create: (context) => PromotionPostProvider()),
      ChangeNotifierProvider(create: (context) => ApplicationProvider(getIt<ApplicationUseCase>())),
      ChangeNotifierProvider(create: (context) => ReviewProvider(getIt<ReviewUseCase>())),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(getIt<UserUseCase>())),
        BlocProvider(create: (context) => UserBloc(getIt<UserUseCase>())),
        BlocProvider(create: (context) => RecruitPostBloc(getIt<RecruitPostUseCase>())),
        BlocProvider(create: (context) => ImageBloc(getIt<ImageUseCase>())),
        BlocProvider(create: (context) => AppBloc(getIt<ApplicationUseCase>(), getIt<RecruitPostUseCase>())),
        BlocProvider(create: (context) => ReviewBloc(getIt<ReviewUseCase>())),
      ], child: const MetaDataSetting(),
    ),
  ));
}
