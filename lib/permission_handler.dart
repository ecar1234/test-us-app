import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_us_app/presentation/pages/home/user_page.dart';
import 'package:test_us_app/presentation/pages/my_pages/user_info/password_update_page.dart';
import 'package:test_us_app/presentation/provider/firebase_messaging_provider.dart';
import 'package:test_us_app/presentation/routes/app_router.dart';
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
    debugPrint('[SYSTEM] init permission');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
    // final messagingProvider = context.read<FirebaseMessagingProvider>();
    // Future.microtask(() async {
    //   MessagingService().init(messagingProvider);
    //   await _initSystem();
    //   NotificationService().init();
    //   await _initializeNotification();
    // });
    //
    // WidgetsBinding.instance.addPostFrameCallback((_)async{
    //   if (mounted) {
    //     context.pushReplacementNamed('meta_setting');
    //   }
    // });
  }

  Future<void> _initializeApp() async {
    try {
      // 1. 필요한 비동기 시스템 초기화 진행
      final messagingProvider = context.read<FirebaseMessagingProvider>();
      MessagingService().init(messagingProvider);

      await _initSystem(); // 이제 context가 준비되었으므로 안전합니다.
      NotificationService().init();
      await _initializeNotification();

    } catch (e, stackTrace) {
      // 에러 발생 시 디버그 콘솔에 출력하여 원인을 파악할 수 있게 함
      debugPrint('[SYSTEM] 초기화 중 예외 발생: $e\n$stackTrace');
    } finally {
      // 2. try 안에서 성공하든, catch로 에러가 빠지든 무조건 실행되는 영역
      if (mounted) {
        context.pushReplacementNamed('meta_setting');

        // 3. 네이티브 스플래시 무조건 제거 보장
        FlutterNativeSplash.remove();
      }
    }
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
    return SafeArea(child: Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    ));
  }
}
