import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/base_post_bloc/base_post_bloc.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/base_post_bloc/base_post_event.dart';
import 'package:test_us_app/presentation/pages/home/user_page.dart';
import 'package:test_us_app/presentation/pages/my_pages/user_info/password_update_page.dart';
import 'package:test_us_app/presentation/provider/firebase_messaging_provider.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:test_us_app/services/firebase/messaging_service.dart';
import 'package:test_us_app/services/notification/notification_service.dart';
import 'package:test_us_app/services/theme_provider.dart';

import 'domain/entities/firebase_messaging_entity.dart';
import 'mata_data_setting.dart';

class PermissionHandler extends StatefulWidget {
  const PermissionHandler({super.key});

  @override
  State<PermissionHandler> createState() => _PermissionHandlerState();
}

class _PermissionHandlerState extends State<PermissionHandler> {
  @override
  void initState() {
    super.initState();

    final messagingProvider = context.read<FirebaseMessagingProvider>();
    Future.microtask(() async {
      MessagingService().init(messagingProvider);
      await _initSystem();
      NotificationService().init();
      await _initializeNotification();
      if (mounted) {
        Get.off(() => const MetaDataSetting());
      }
    });
  }

  Future<void> _initSystem() async {
    GetIt.I.get<ResponsiveHeightProvider>().setHeight(context);
    context.read<ThemeProvider>().getIsDarkMod();
    debugPrint('[SYSTEM] set height / get bright mode');
  }

  Future<void> _initializeNotification() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

// 포그라운드
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessageProcessing(message);
    });
// 백그라운드
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessageProcessing(message, shouldNavigate: true);
// 이동 로직 추가 (권장)
    });
// 앱 종료시
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message == null) return;
      _handleMessageProcessing(message, shouldNavigate: true);
    });

// 토큰 업데이트
    FirebaseMessaging.instance.onTokenRefresh.listen((String messagingToken) {
      MessagingService().saveToken(messagingToken);
    });

    debugPrint('[SYSTEM] init FCM completed');
  }

  void _handleMessageProcessing(RemoteMessage message, {bool shouldNavigate = false}) {
    final notification = FirebaseMessagingEntity(
      id: message.messageId!,
      title: message.notification?.title,
      body: message.notification?.body,
      createdAt: DateTime.now(),
      data: message.data,
      isRead: false,
    );

// 데이터 저장
    MessagingService().saveNotification(notification);

// 이동 로직이 필요한 경우 (클릭 이벤트 등)
    if (shouldNavigate) {
      NotificationService().showNotification(message);
    }
    debugPrint('[SYSTEM] set FCM processing completed');
  }


  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    return GetMaterialApp(
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
      navigatorObservers: [BotToastNavigatorObserver()],
      getPages: [
        GetPage(name: '/userPage', page: () => const UserPage()),
        GetPage(name: '/passwordUpdatePage', page: () => const PasswordUpdatePage())
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'), // 한국어
        Locale('en', 'US'), // 영어
      ],
      home: const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(), // 혹은 앱 로고 이미지
        ),
      ),
    );
  }
}
