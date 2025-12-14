import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/domain/entities/firebase_messaging_entity.dart';
import 'package:test_us_app/presentation/bloc/app_bloc/app_bloc.dart';
import 'package:test_us_app/presentation/bloc/auth_bloc/auth_event.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/base_post_bloc/base_post_bloc.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/base_post_bloc/base_post_state.dart';
import 'package:test_us_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:test_us_app/presentation/pages/post/post_main_page.dart';
import 'package:test_us_app/presentation/pages/purchase_page.dart';
import 'package:test_us_app/presentation/pages/search_page.dart';
import 'package:test_us_app/presentation/provider/application_provider.dart';
import 'package:test_us_app/presentation/provider/post_provider/base_post_provider.dart';
import 'package:test_us_app/presentation/provider/post_provider/promotion_post_provider.dart';
import 'package:test_us_app/presentation/provider/post_provider/recruit_post_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/presentation/pages/user_page.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_us_app/services/theme_provider.dart';

import '../../data/sharedPreferences/auth_preference.dart';
import '../../data/sharedPreferences/firebase_messaging_preference.dart';
import '../../services/firebase/messaging_service.dart';
import '../bloc/app_bloc/app_event.dart';
import '../bloc/app_bloc/app_state.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../bloc/post_blocs/base_post_bloc/base_post_event.dart';
import '../bloc/post_blocs/recruit_post_bloc/recruit_post_bloc.dart';
import '../bloc/post_blocs/recruit_post_bloc/recruit_post_event.dart';
import '../bloc/post_blocs/recruit_post_bloc/recruit_post_state.dart';
import '../bloc/user_bloc/user_event.dart';
import '../components/custom_bottom_bar.dart';
import '../provider/firebase_messaging_provider.dart';
import 'home_page.dart';

class MetaDataSetting extends StatefulWidget {
  const MetaDataSetting({super.key});

  @override
  State<MetaDataSetting> createState() => _MetaDataSettingState();
}

class _MetaDataSettingState extends State<MetaDataSetting> {
  final pref = AuthPreference.instance;
  final firebasePref = FirebaseMessagingPreference.instance;
  final logger = Logger();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MessagingService().init(context.read<FirebaseMessagingProvider>());
    Future.microtask(() async {
      await _init();
      _initializeNotification();
    });
  }

  Future<void> _init() async {
    GetIt.I.get<ResponsiveHeightProvider>().setHeight(context);
    context.read<ThemeProvider>().getIsDarkMod();
    context.read<BasePostBloc>().add(ServiceStartEvent());
  }

  Future<void> _initializeNotification() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 앱이 켜져 있을 때
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = FirebaseMessagingEntity(
        id: message.messageId!,
        title: message.notification?.title,
        body: message.notification?.body,
        createdAt: DateTime.now(),
        data: message.data,
        isRead: false,
      );
      MessagingService().saveNotification(notification);
    });
    // 앱이 꺼져 있을 때
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final notification = FirebaseMessagingEntity(
        id: message.messageId!,
        title: message.notification?.title,
        body: message.notification?.body,
        createdAt: DateTime.now(),
        data: message.data,
        isRead: false,
      );
      MessagingService().saveNotification(notification);
    });
    // 앱이 백그라운드 상태일 때
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if(message == null) return;
      final notification = FirebaseMessagingEntity(
        id: message.messageId!,
        title: message.notification?.title,
        body: message.notification?.body,
        createdAt: DateTime.now(),
        data: message.data,
        isRead: false,
      );
      MessagingService().saveNotification(notification);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    return MultiBlocListener(
      listeners: [
        BlocListener<BasePostBloc, BasePostState>(
          listener: (context, state) async {
            if (state.state == BasePostLoadState.getInitPostCompletedState) {
              context.read<AuthBloc>().add(TokenCheckEvent());
              context
                  .read<BasePostProvider>()
                  .getInitPosts(state.favoritePosts!, state.recruitPosts!, state.promotionPosts!);
              context.read<RecruitPostProvider>().getInitPosts(state.recruitPosts!);
              context.read<PromotionPostProvider>().getInitPromotionPosts(state.promotionPosts!);
              FlutterNativeSplash.remove();
            }
          },
          listenWhen: (preState, state) => state.state == BasePostLoadState.getInitPostCompletedState,
        ),
        BlocListener<BasePostBloc, BasePostState>(
          listener: (context, state) async {
            if (state.state == BasePostLoadState.getUserInitPostsCompletedState) {
              final recruit = state.initData!['recruitPosts'];
              final promotion = state.initData!['promotionPosts'];
              context.read<BasePostProvider>().setUserInitData(recruit, promotion);
            }
          },
          listenWhen: (preState, state) => state.state == BasePostLoadState.getUserInitPostsCompletedState,
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
            final userProvider = context.read<UserProvider>();
            final firebaseProvider = context.read<FirebaseMessagingProvider>();
            final basePostBloc = context.read<BasePostBloc>();
            final applicationBloc = context.read<AppBloc>();
            final userBloc = context.read<UserBloc>();

            if (state.state == UserAuthState.loginCompletedState) {
              await userProvider.autoLogin(state.token!, state.user!);
              basePostBloc.add(RequestUserInItDataEvent(state.token!, state.user!.id!));
              applicationBloc.add(RequestMyApplicationsEvent(state.token!, state.user!.id!));

              final messagingToken = await _firebaseMessaging.getToken();
              logger.d('firebase token : $messagingToken');
              if (messagingToken == null) {
                return;
              }

              final deviceType = Platform.isAndroid ? 'android' : 'ios';
              userBloc.add(CreateFirebaseTokenEvent(state.token, messagingToken, state.user!.id, deviceType));
              firebaseProvider.setFirebaseToken(messagingToken);
              firebaseProvider.getNotification();
            }
          },
        ),
        BlocListener<AppBloc, AppState>(listener: (context, state) async {
          if (state.state == UserAppState.getUserApplicationsCompletedState) {
            context.read<ApplicationProvider>().getMyApplications(state.applications!);

            final postIds = state.applications!.map((e) => e.postId!).toList();
            final token = context.read<UserProvider>().token ?? '';
            context.read<RecruitPostBloc>().add(RequestAppRecruitPosts(token, postIds));
          }
        }),
        BlocListener<RecruitPostBloc, RecruitPostState>(
          listener: (context, state) async {
            if (state.state == RecruitPostLoadState.getAppRecruitPostsCompletedState) {
              context.read<ApplicationProvider>().setUserApplicationPosts(state.posts!);
            }
          },
        )
      ],
      child: GetMaterialApp(
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
            fontFamily: GoogleFonts.notoSans().fontFamily),
        //     .copyWith(
        //         inputDecorationTheme: InputDecorationTheme(
        //   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        // )),
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
        home: const MainPage(),
      ),
    );
  }

  Future<void> _firebaseMessagingTokenLogic(BuildContext context) async {
    final token = context.read<UserProvider>().token ?? '';
    final userId = context.read<UserProvider>().user?.id ?? '';
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainState();
}

class _MainState extends State<MainPage> {
  int _currentIdx = 0;

  late List<Widget> _pageList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageList = [
      HomePage(
        onTap: (idx) {
          setState(() {
            _currentIdx = idx;
          });
        },
      ),
      const SearchPage(),
      const UserPage(),
      const PurchasePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei ?? MediaQuery.sizeOf(context).height - 120;
    return SafeArea(
        child: PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        if (context.mounted) {
          setState(() {
            _currentIdx = 0;
          });
        }
      },
      child: Selector<ThemeProvider, bool>(
          selector: (contest, provider) => provider.isDarkMode,
          builder: (context, isDarkMode, chile) {
            return Container(
              decoration: BoxDecoration(color: isDarkMode ? Colors.black : Colors.white),
              child: Stack(children: [
                SizedBox(
                  height: hei - 10,
                  child: _pageList[_currentIdx],
                ),
                Positioned(
                  bottom: 0,
                  child: CustomBottomBar(
                    currentIndex: _currentIdx,
                    onTap: (idx) {
                      setState(() {
                        _currentIdx = idx;
                      });
                    },
                  ),
                )
              ]),
            );
          }),
    ));
  }
}
