import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
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
import 'package:test_us_app/presentation/components/disconnected_page.dart';
import 'package:test_us_app/presentation/pages/main_page.dart';
import 'package:test_us_app/presentation/provider/application_provider.dart';
import 'package:test_us_app/presentation/provider/post_provider/base_post_provider.dart';
import 'package:test_us_app/presentation/provider/purchase_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/services/auth/auth_service.dart';
import 'package:test_us_app/services/network/network_controller.dart';

import 'data/sharedPreferences/firebase_messaging_preference.dart';

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
    super.initState();

    FlutterNativeSplash.remove();
    _checkAndRequestPermissions();
    _requestPostInitData();
    // final network = context.read<NetworkController>();
    // if(network.isConnected){
    // }
  }

  Future<void> _checkAndRequestPermissions() async {
    // 1. 필요한 3가지 권한 동시에 요청
    debugPrint('[Permission request] start!!');
    Map<Permission, PermissionStatus> statuses =
        await [Permission.photos, Permission.notification].request();

    final isAllGranted =
        statuses.values.every((status) => status == PermissionStatus.granted);

    // final isAllGranted = statuses.entries.every((entry) {
    //   if (entry.key == Permission.photos) {
    //     return entry.value.isGranted || entry.value.isLimited;
    //   }
    //   return entry.value.isGranted;
    // });

    if (isAllGranted) {
      debugPrint('[SYSTEM] Permission handler pass');
    } else {
      // 하나라도 거부 시 ➡️ 플러터 화면 위에 알럿 팝업 노출
      debugPrint('[SYSTEM] Permission handler false');
      if (mounted) {
        _showPermissionDeniedDialog();
        return;
      }
    }
  }

  void _requestPostInitData() {
    context.read<BasePostBloc>().add(RequestInitDataEvent());
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // 바깥 터치로 안 닫히게 설정
      builder: (context) => AlertDialog(
        title: const Text('필수 권한 안내'),
        content:
            const Text('앱 사용을 위해 카메라, 갤러리, 알림 권한이 필수적입니다. 허용되지 않아 앱을 종료합니다.'),
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
    return MultiBlocListener(listeners: [
      BlocListener<BasePostBloc, BasePostState>(
        listener: (context, state) async {
          context.read<AuthBloc>().add(TokenCheckEvent());
          context.read<BasePostProvider>().getInitPosts(
              state.favoritePosts!, state.recruitPosts!, state.promotionPosts!);
          // context.read<RecruitPostProvider>().getInitPosts(state.recruitPosts!);
          // context.read<PromotionPostProvider>().getInitPromotionPosts(state.promotionPosts!);
        },
        listenWhen: (preState, state) =>
            state.state == BasePostLoadState.getInitPostCompletedState,
      ),
      BlocListener<BasePostBloc, BasePostState>(
        listener: (context, state) async {
          final recruit = state.initData!['recruitPosts'];
          final promotion = state.initData!['promotionPosts'];
          context.read<BasePostProvider>().setUserInitData(recruit, promotion);
        },
        listenWhen: (preState, state) =>
            state.state == BasePostLoadState.getUserInitPostsCompletedState,
      ),
      BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          context.read<UserProvider>().logout();
          context.read<AuthBloc>().add(LogoutEvent());
          Get.snackbar("알림", "자동 로그인에 실패 했습니다. 다시 로그인 해주세요.",
              duration: const Duration(seconds: 3));
        },
        listenWhen: (prev, current) =>
            current.state == UserAuthState.errorState,
      ),
      BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          GetIt.I.get<AuthService>().loginCompletionHandler(context, state);
        },
        listenWhen: (preState, state) =>
            state.state == UserAuthState.loginCompletedState,
      ),
      BlocListener<AppBloc, AppState>(
          listener: (context, state) async {
            context
                .read<ApplicationProvider>()
                .setMyApplications(state.applications!);

            final postIds =
                state.applications!.map((e) => e.postInfo!.postId!).toList();
            final token = context.read<UserProvider>().token ?? '';
            context
                .read<RecruitPostBloc>()
                .add(RequestAppRecruitPosts(token, postIds));
          },
          listenWhen: (prev, state) =>
              state.state == UserAppState.getUserApplicationsCompletedState),
      BlocListener<RecruitPostBloc, RecruitPostState>(
        listener: (context, state) async {
          context
              .read<ApplicationProvider>()
              .setUserApplicationPosts(state.posts!);
        },
        listenWhen: (preState, state) =>
            state.state ==
            RecruitPostLoadState.getAppRecruitPostsCompletedState,
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
        listenWhen: (prevState, state) =>
            state.state == UserDataState.getUserDataLoadedState,
      ),
      BlocListener<PurchaseBloc, PurchaseState>(
        listener: (context, state) async {
          if (state is PurchaseInitCompletedState) {
            final userProvider = context.read<UserProvider>();
            context.read<PurchaseBloc>().add(RequestUserPurchaseInfo(
                token: userProvider.token!, userId: userProvider.user!.id!));
          } else if (state is GetUserPurchaseInfoCompletedState) {
            context
                .read<PurchaseProvider>()
                .getUserPurchaseList(state.subscribeList);
            context.read<PurchaseBloc>().add(PurchaseOfferings());
          } else if (state is GetOfferingCompletedState) {
            context.read<PurchaseProvider>().getProducts(state.products);
          }
        },
        // listenWhen: (preState, state) => state.state == PurchaseProgressState.initCompleted,
      )
    ], child: const MainPage());
  }
}
