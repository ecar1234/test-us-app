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
import 'package:test_us_app/presentation/bloc/purchase_bloc/purchase_event.dart';
import 'package:test_us_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:test_us_app/presentation/bloc/user_bloc/user_state.dart';
import 'package:test_us_app/presentation/pages/home/purchase_page.dart';
import 'package:test_us_app/presentation/pages/home/search_page.dart';
import 'package:test_us_app/presentation/pages/post/promotion_post_pages/promotion_post_create_page.dart';
import 'package:test_us_app/presentation/pages/post/tester_post_pages/recruit_post_create_page.dart';
import 'package:test_us_app/presentation/provider/application_provider.dart';
import 'package:test_us_app/presentation/provider/post_provider/base_post_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/presentation/pages/home/user_page.dart';
import 'package:test_us_app/services/auth/auth_service.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_us_app/services/theme_provider.dart';

import '../../data/sharedPreferences/firebase_messaging_preference.dart';
import '../../services/firebase/messaging_service.dart';
import '../../services/notification/notification_service.dart';
import '../provider/purchase_provider.dart';
import '../bloc/app_bloc/app_state.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../bloc/post_blocs/base_post_bloc/base_post_event.dart';
import '../bloc/post_blocs/recruit_post_bloc/recruit_post_bloc.dart';
import '../bloc/post_blocs/recruit_post_bloc/recruit_post_event.dart';
import '../bloc/post_blocs/recruit_post_bloc/recruit_post_state.dart';
import '../bloc/purchase_bloc/purchase_bloc.dart';
import '../bloc/purchase_bloc/purchase_state.dart';
import '../components/custom_bottom_bar.dart';
import '../components/one_action_dialog.dart';
import '../provider/firebase_messaging_provider.dart';
import '../provider/post_provider/promotion_post_provider.dart';
import '../provider/post_provider/recruit_post_provider.dart';
import 'home/home_page.dart';

class MetaDataSetting extends StatefulWidget {
  const MetaDataSetting({super.key});

  @override
  State<MetaDataSetting> createState() => _MetaDataSettingState();
}

class _MetaDataSettingState extends State<MetaDataSetting> {
  final firebasePref = FirebaseMessagingPreference.instance;
  final logger = Logger();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MessagingService().init(context.read<FirebaseMessagingProvider>());
    Future.microtask(() async {
      await _initSystem();
      NotificationService().init();
      await _initializeNotification();

    });
  }

  Future<void> _initSystem() async {
    GetIt.I.get<ResponsiveHeightProvider>().setHeight(context);
    context.read<ThemeProvider>().getIsDarkMod();
    context.read<BasePostBloc>().add(ServiceStartEvent());
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
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    return MultiBlocListener(
      listeners: [
        BlocListener<BasePostBloc, BasePostState>(
          listener: (context, state) async {
            context.read<AuthBloc>().add(TokenCheckEvent());
            context
                .read<BasePostProvider>()
                .getInitPosts(state.favoritePosts!, state.recruitPosts!, state.promotionPosts!);
            // context.read<RecruitPostProvider>().getInitPosts(state.recruitPosts!);
            // context.read<PromotionPostProvider>().getInitPromotionPosts(state.promotionPosts!);
            FlutterNativeSplash.remove();
          },
          listenWhen: (preState, state) => state.state == BasePostLoadState.getInitPostCompletedState,
        ),
        BlocListener<BasePostBloc, BasePostState>(
          listener: (context, state) async {
            final recruit = state.initData!['recruitPosts'];
            final promotion = state.initData!['promotionPosts'];
            context.read<BasePostProvider>().setUserInitData(recruit, promotion);
          },
          listenWhen: (preState, state) => state.state == BasePostLoadState.getUserInitPostsCompletedState,
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            context.read<UserProvider>().logout();
            context.read<AuthBloc>().add(LogoutEvent());
            Get.snackbar("알림", "자동 로그인에 실패 했습니다. 다시 로그인 해주세요.", duration: const Duration(seconds: 3));
          },
          listenWhen: (prev, current) => current.state == UserAuthState.errorState,
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
            GetIt.I.get<AuthService>().loginCompletionHandler(context, state);
          },
          listenWhen: (preState, state) => state.state == UserAuthState.loginCompletedState,
        ),
        BlocListener<AppBloc, AppState>(
            listener: (context, state) async {
              context.read<ApplicationProvider>().setMyApplications(state.applications!);

              final postIds = state.applications!.map((e) => e.postId!).toList();
              final token = context.read<UserProvider>().token ?? '';
              context.read<RecruitPostBloc>().add(RequestAppRecruitPosts(token, postIds));
            },
            listenWhen: (prev, state) => state.state == UserAppState.getUserApplicationsCompletedState),
        BlocListener<RecruitPostBloc, RecruitPostState>(
          listener: (context, state) async {
            context.read<ApplicationProvider>().setUserApplicationPosts(state.posts!);
          },
          listenWhen: (preState, state) => state.state == RecruitPostLoadState.getAppRecruitPostsCompletedState,
        ),
        BlocListener<UserBloc, UserState>(
          listener: (context, state) async {
            final savedUser = context.read<UserProvider>().user!;
            if (savedUser.nickname != state.user!.nickname) {
              savedUser.nickname = state.user!.nickname;
              savedUser.profileImg = state.user!.profileImg;
              savedUser.userType = state.user!.userType;
              savedUser.role = state.user!.role;
              context.read<UserProvider>().updateUserInfo(savedUser);
            }
          },
          listenWhen: (prevState, state) => state.state == UserDataState.getUserDataLoadedState,
        ),
        BlocListener<PurchaseBloc, PurchaseState>(
          listener: (context, state) async {
            if(state is PurchaseInitCompletedState){
              final userProvider = context.read<UserProvider>();
              context.read<PurchaseBloc>().add(RequestUserPurchaseInfo(token: userProvider.token!, userId: userProvider.user!.id!));
            }else if(state is GetUserPurchaseInfoCompletedState){
              context.read<PurchaseProvider>().getUserPurchaseList(state.subscribeList);
              context.read<PurchaseBloc>().add(PurchaseOfferings());
            }else if(state is GetOfferingCompletedState){
              context.read<PurchaseProvider>().getProducts(state.products);
            }
          },
          // listenWhen: (preState, state) => state.state == PurchaseProgressState.initCompleted,
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
        home: const MainPage(),
      ),
    );
  }

// Future<void> _firebaseMessagingTokenLogic(BuildContext context) async {
//   final token = context.read<UserProvider>().token ?? '';
//   final userId = context.read<UserProvider>().user?.id ?? '';
// }
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
            // final activePlan = context.read<PurchasesManagements>().subscribedItem;
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
                    onRecruit: () {
                      Get.to(() => RecruitPostCreatePage());
                    },
                    onPromotion: () {
                      Get.to(() => PromotionPostCreatePage());
                    },
                  ),
                )
              ]),
            );
          }),
    ));
  }
}
