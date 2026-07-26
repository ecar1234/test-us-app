import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_us_app/presentation/pages/home/user_page.dart';
import 'package:test_us_app/presentation/pages/my_pages/user_info/password_update_page.dart';
import 'package:test_us_app/services/theme_provider.dart';

import 'mata_data_setting.dart';

class PermissionHandler extends StatefulWidget {
  const PermissionHandler({super.key});

  @override
  State<PermissionHandler> createState() => _PermissionHandlerState();
}

class _PermissionHandlerState extends State<PermissionHandler> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkAndRequestPermissions();
  }

  Future<void> _checkAndRequestPermissions() async {
    // 1. 필요한 3가지 권한 동시에 요청
    debugPrint('[Permission request] start!!');
    Map<Permission, PermissionStatus> statuses = await [Permission.photos, Permission.notification].request();

    final isAllGranted = statuses.values.every((status) => status == PermissionStatus.granted);

    debugPrint('[Permission request] result : $isAllGranted');

    if (isAllGranted) {
      // 모두 성공 시 ➡️ 메인 페이지로 이동 (더이상 스플래시로 못 돌아오게 replacement)
      if (mounted) {
        FlutterNativeSplash.remove();
        Get.off(() => const MetaDataSetting());
      }
    } else {
      // 하나라도 거부 시 ➡️ 플러터 화면 위에 알럿 팝업 노출
      if (mounted) {
        _showPermissionDeniedDialog();
      }
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // 바깥 터치로 안 닫히게 설정
      builder: (context) => AlertDialog(
        title: const Text('필수 권한 안내'),
        content: const Text('앱 사용을 위해 카메라, 갤러리, 알림 권한이 필수적입니다. 허용되지 않아 앱을 종료합니다.'),
        actions: [
          TextButton(
            onPressed: () {
              if (Platform.isAndroid) {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              } else if (Platform.isIOS) {
                exit(0);
              }
            },
            child: const Text('종료'),
          ),
          TextButton(
            onPressed: () async {
              await openAppSettings();
            },
            child: const Text('설정으로 이동'),
          ),
        ],
      ),
    );
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
      home: const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(), // 혹은 앱 로고 이미지
        ),
      ),
    );
  }
}
