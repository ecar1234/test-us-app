import 'package:bot_toast/bot_toast.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/permission_handler.dart';
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
import 'package:test_us_app/presentation/provider/application_provider.dart';
import 'package:test_us_app/presentation/provider/firebase_messaging_provider.dart';
import 'package:test_us_app/presentation/provider/post_provider/base_post_provider.dart';
import 'package:test_us_app/presentation/provider/post_provider/promotion_post_provider.dart';
import 'package:test_us_app/presentation/provider/post_provider/recruit_post_provider.dart';
import 'package:test_us_app/presentation/provider/purchase_provider.dart';
import 'package:test_us_app/presentation/provider/review_provider.dart';
import 'package:test_us_app/presentation/provider/room_provider.dart';
import 'package:test_us_app/presentation/provider/socket_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/presentation/routes/app_router.dart';
import 'package:test_us_app/service_locator.dart';
import 'package:test_us_app/services/theme_provider.dart';

import 'domain/use_cases/application_usecase.dart';
import 'domain/use_cases/base_post_usecase.dart';
import 'domain/use_cases/image_usecase.dart';
import 'domain/use_cases/message_usecase.dart';
import 'domain/use_cases/promotion_post_usecase.dart';
import 'domain/use_cases/purchase_usecase.dart';
import 'domain/use_cases/recruit_post_usecase.dart';
import 'domain/use_cases/review_usecase.dart';
import 'domain/use_cases/user_usecase.dart';


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    debugPrint('[SYSTEM] init my app');
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
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
        ChangeNotifierProvider(create: (context) => PurchaseProvider()),
        ChangeNotifierProxyProvider<RoomProvider, SocketProvider>(
          create: (context) => GetIt.I.get<SocketProvider>(),
          update: (context, roomProvider, socketProvider) {
            return socketProvider!..setRoomProvider(roomProvider);
          },
        ),
        // ChangeNotifierProvider.value(value: networkController)
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
          BlocProvider(create: (context) => PurchaseBloc(getIt<PurchaseUseCase>(), getIt<InAppPurchase>()))
        ], child: Builder(builder: (context){
        bool isDarkMode = context.watch<ThemeProvider>().isDarkMode;
        return MaterialApp.router(
          routerConfig: AppRouter.router,
          theme: FlexThemeData.light(
            scheme: FlexScheme.damask,
            // surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
            // blendLevel: 9,
            subThemesData: const FlexSubThemesData(
              interactionEffects: true,
              tintedDisabledControls: true,
              useM2StyleDividerInM3: true,
              inputDecoratorIsFilled: true,
              inputDecoratorBorderType: FlexInputBorderType.outline,
              alignedDropdown: true,
              navigationRailUseIndicator: true,
            ),
            keyColors: const FlexKeyColors(
              keepPrimary: true,
              keepSecondary: true,
              keepTertiary: true,
              keepError: true,
              keepPrimaryContainer: true,
              keepSecondaryContainer: true,
              keepTertiaryContainer: true,
              keepErrorContainer: true,
            ),
            variant: FlexSchemeVariant.monochrome,
// Direct ThemeData properties.
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
            useMaterial3: true,
            swapLegacyOnMaterial3: true,
            fontFamily: GoogleFonts.notoSans().fontFamily,
          ),
          darkTheme: FlexThemeData.dark(
              scheme: FlexScheme.damask,
              subThemesData: const FlexSubThemesData(
                interactionEffects: true,
                tintedDisabledControls: true,
                useM2StyleDividerInM3: true,
                inputDecoratorIsFilled: true,
                inputDecoratorBorderType: FlexInputBorderType.outline,
                alignedDropdown: true,
                navigationRailUseIndicator: true,
              ),
              keyColors: const FlexKeyColors(
                keepPrimary: true,
                keepSecondary: true,
                keepTertiary: true,
                keepError: true,
                keepPrimaryContainer: true,
                keepSecondaryContainer: true,
                keepTertiaryContainer: true,
                keepErrorContainer: true,
              ),
              variant: FlexSchemeVariant.monochrome,
// Direct ThemeData properties.
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
              cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
              useMaterial3: true,
              swapLegacyOnMaterial3: true),
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          builder: BotToastInit(),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ko', 'KR'), // 한국어
            Locale('en', 'US'), // 영어
          ],
        );
      }),
      ),
    );
  }
}
