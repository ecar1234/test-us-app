import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/presentation/bloc/app_bloc/app_bloc.dart';
import 'package:test_us_app/presentation/bloc/app_bloc/app_state.dart';
import 'package:test_us_app/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:test_us_app/presentation/bloc/auth_bloc/auth_event.dart';
import 'package:test_us_app/presentation/bloc/auth_bloc/auth_state.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/base_post_bloc/base_post_bloc.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/base_post_bloc/base_post_event.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/base_post_bloc/base_post_state.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/recruit_post_bloc/recruit_post_bloc.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/recruit_post_bloc/recruit_post_event.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/recruit_post_bloc/recruit_post_state.dart';
import 'package:test_us_app/presentation/bloc/purchase_bloc/purchase_bloc.dart';
import 'package:test_us_app/presentation/bloc/purchase_bloc/purchase_event.dart';
import 'package:test_us_app/presentation/bloc/purchase_bloc/purchase_state.dart';
import 'package:test_us_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:test_us_app/presentation/bloc/user_bloc/user_state.dart';
import 'package:test_us_app/presentation/pages/main_page.dart';
import 'package:test_us_app/presentation/provider/application_provider.dart';
import 'package:test_us_app/presentation/provider/firebase_messaging_provider.dart';
import 'package:test_us_app/presentation/provider/post_provider/base_post_provider.dart';
import 'package:test_us_app/presentation/provider/purchase_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/services/auth/auth_service.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:test_us_app/services/firebase/messaging_service.dart';
import 'package:test_us_app/services/notification/notification_service.dart';
import 'package:test_us_app/services/theme_provider.dart';

import 'data/sharedPreferences/firebase_messaging_preference.dart';
import 'domain/entities/firebase_messaging_entity.dart';

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
    context.read<BasePostBloc>().add(RequestInitDataEvent());
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
    return MultiBlocListener(
        listeners: [
          BlocListener<BasePostBloc, BasePostState>(
            listener: (context, state) async {
              context.read<AuthBloc>().add(TokenCheckEvent());
              context
                  .read<BasePostProvider>()
                  .getInitPosts(state.favoritePosts!, state.recruitPosts!, state.promotionPosts!);
              FlutterNativeSplash.remove();
              // context.read<RecruitPostProvider>().getInitPosts(state.recruitPosts!);
              // context.read<PromotionPostProvider>().getInitPromotionPosts(state.promotionPosts!);
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
        child: const MainPage());
  }
  // Future<void> _firebaseMessagingTokenLogic(BuildContext context) async {
//   final token = context.read<UserProvider>().token ?? '';
//   final userId = context.read<UserProvider>().user?.id ?? '';
// }
}
