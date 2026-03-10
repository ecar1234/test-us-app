import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:test_us_app/domain/use_cases/application_usecase.dart';
import 'package:test_us_app/domain/use_cases/image_usecase.dart';
import 'package:test_us_app/presentation/bloc/app_bloc/app_bloc.dart';
import 'package:test_us_app/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:test_us_app/presentation/bloc/image_bloc/image_bloc.dart';
import 'package:test_us_app/presentation/bloc/message_bloc/message_bloc.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/base_post_bloc/base_post_bloc.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/promotion_bloc/promotion_bloc.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/recruit_post_bloc/recruit_post_bloc.dart';
import 'package:test_us_app/presentation/bloc/purchase_bloc/purchase_bloc.dart';
import 'package:test_us_app/presentation/bloc/review_bloc/review_bloc.dart';
import 'package:test_us_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:test_us_app/presentation/pages/main_page.dart';
import 'package:test_us_app/presentation/provider/application_provider.dart';
import 'package:test_us_app/presentation/provider/firebase_messaging_provider.dart';
import 'package:test_us_app/presentation/provider/room_provider.dart';
import 'package:test_us_app/presentation/provider/post_provider/base_post_provider.dart';
import 'package:test_us_app/presentation/provider/post_provider/promotion_post_provider.dart';
import 'package:test_us_app/presentation/provider/post_provider/recruit_post_provider.dart';
import 'package:test_us_app/presentation/provider/review_provider.dart';
import 'package:test_us_app/presentation/provider/socket_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/services/revenue_cat_purchases/purchase_management.dart';
import 'package:test_us_app/services/theme_provider.dart';

import 'domain/use_cases/base_post_usecase.dart';
import 'domain/use_cases/firebase_messaging_usecase.dart';
import 'domain/use_cases/message_usecase.dart';
import 'domain/use_cases/promotion_post_usecase.dart';
import 'domain/use_cases/recruit_post_usecase.dart';
import 'domain/use_cases/review_usecase.dart';
import 'domain/use_cases/user_usecase.dart';

// 1. 백그라운드 메시지 핸들러 (앱이 꺼져있거나 백그라운드일 때 실행)
// 반드시 main 함수 밖, 최상위에 선언해야 합니다.
@pragma('vm:entry-point') // 릴리즈 모드에서도 함수가 트리쉐이킹 되지 않도록 설정
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  await serviceLocator(_firebaseMessagingBackgroundHandler);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => GetIt.I.get<FirebaseMessagingProvider>()),
      ChangeNotifierProvider(create: (context) => GetIt.I.get<UserProvider>()),
      ChangeNotifierProvider(create: (context) => BasePostProvider()),
      ChangeNotifierProvider(create: (context) => RecruitPostProvider(getIt<RecruitPostUseCase>())),
      ChangeNotifierProvider(create: (context) => PromotionPostProvider()),
      ChangeNotifierProvider(create: (context) => ApplicationProvider(getIt<ApplicationUseCase>())),
      ChangeNotifierProvider(create: (context) => ReviewProvider(getIt<ReviewUseCase>())),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => RoomProvider(getIt<MessageUseCase>())),
      ChangeNotifierProvider(create: (context) => PurchasesManagements()),
      ChangeNotifierProxyProvider<RoomProvider, SocketProvider>(
          create: (context) => GetIt.I.get<SocketProvider>(),
        update: (context, roomProvider, socketProvider) {
          return socketProvider!..setRoomProvider(roomProvider);
        },
      ),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(getIt<UserUseCase>())),
        BlocProvider(create: (context) => UserBloc(getIt<UserUseCase>(), getIt<ReviewUseCase>())),
        BlocProvider(create: (context) => BasePostBloc(getIt<BasePostUseCase>())),
        BlocProvider(create: (context) => RecruitPostBloc(getIt<RecruitPostUseCase>())),
        BlocProvider(create: (context) => PromotionBloc(getIt<PromotionPostUseCase>())),
        BlocProvider(create: (context) => ImageBloc(getIt<ImageUseCase>())),
        BlocProvider(create: (context) => AppBloc(getIt<ApplicationUseCase>(), getIt<RecruitPostUseCase>(), getIt<UserUseCase>())),
        BlocProvider(create: (context) => ReviewBloc(getIt<ReviewUseCase>(), getIt<UserUseCase>())),
        BlocProvider(create: (context) => MessageBloc(getIt<MessageUseCase>())),
        BlocProvider(create: (context) => PurchaseBloc())
      ], child: const MetaDataSetting(),
    ),
  ));
}
