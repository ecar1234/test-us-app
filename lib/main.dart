import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:test_us_app/my_app.dart';
import 'package:test_us_app/service_locator.dart';
import 'package:test_us_app/services/firebase/firebase_options.dart';

// 1. 백그라운드 메시지 핸들러 (앱이 꺼져있거나 백그라운드일 때 실행)
// 반드시 main 함수 밖, 최상위에 선언해야 합니다.
@pragma('vm:entry-point') // 릴리즈 모드에서도 함수가 트리쉐이킹 되지 않도록 설정
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // final service = NetworkService();
  // final networkController = NetworkController(service);
  // await networkController.initialize();

  await serviceLocator();
  debugPrint('[SYSTEM] run app');
  // 1. 디버깅 핵심: runApp 직전에 스플래시를 강제로 제거하여 내부의 붉은 에러 화면을 확인합니다.
  // FlutterNativeSplash.remove();

  // 2. 프레임워크 렌더링 중 발생하는 에러를 콘솔에 강제 출력합니다.
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('[SYSTEM] 플러터 렌더링 에러: ${details.exception}');
  };

  try {
    runApp(const MyApp());
  } catch (e, stackTrace) {
    debugPrint('[SYSTEM] runApp 동기 에러: $e\n$stackTrace');
  }
}
