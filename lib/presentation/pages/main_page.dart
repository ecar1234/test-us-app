import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/presentation/bloc/auth_bloc/auth_event.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/base_post_bloc/base_post_bloc.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/base_post_bloc/base_post_state.dart';
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

import '../../data/sharedPreferences/auth_preference.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../bloc/post_blocs/base_post_bloc/base_post_event.dart';
import '../components/custom_bottom_bar.dart';
import 'home_page.dart';

class MetaDataSetting extends StatefulWidget {
  const MetaDataSetting({super.key});

  @override
  State<MetaDataSetting> createState() => _MetaDataSettingState();
}

class _MetaDataSettingState extends State<MetaDataSetting> {
  final pref = AuthPreference.instance;
  final logger = Logger();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      await _init();
    });
  }

  Future<void> _init() async {
    GetIt.I.get<ResponsiveHeightProvider>().setHeight(context);
    context.read<BasePostBloc>().add(ServiceStartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BasePostBloc, BasePostState>(
          listener: (context, state) async {
            if (state.state == BasePostLoadState.getInitPostCompletedState) {
              context.read<AuthBloc>().add(TokenCheckEvent());
              context.read<BasePostProvider>().getInitPosts(state.favoritePosts!, state.recruitPosts!, state.promotionPosts!);
              context.read<RecruitPostProvider>().getInitPosts(state.recruitPosts!);
              context.read<PromotionPostProvider>().getInitPromotionPosts(state.promotionPosts!);
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
            final appProvider = context.read<ApplicationProvider>();
            final basePostProvider = context.read<BasePostBloc>();

            if (state.state == UserAuthState.loginCompletedState) {
              await userProvider.autoLogin(state.token!, state.user!);
              basePostProvider.add(RequestUserInItDataEvent(state.token!, state.user!.id!));
              appProvider.getMyApplications(state.token!, state.user!.id!);
            }
          },
        ),
      ],
      child: GetMaterialApp(
        theme: FlexThemeData.light(
                scheme: FlexScheme.ebonyClay,
                surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
                blendLevel: 9,
                subThemesData: const FlexSubThemesData(
                    blendOnLevel: 10,
                    blendOnColors: false,
                    inputDecoratorRadius: 10,
                    inputCursorSchemeColor: SchemeColor.black,
                    inputDecoratorIsFilled: false),
                useMaterial3: true,
                swapLegacyOnMaterial3: true,
                fontFamily: GoogleFonts.notoSans().fontFamily)
            .copyWith(
                inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        )),
        darkTheme: FlexThemeData.dark(
            scheme: FlexScheme.ebonyClay,
            surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
            blendLevel: 15,
            subThemesData: const FlexSubThemesData(
                blendOnLevel: 20,
                inputDecoratorRadius: 10,
                inputCursorSchemeColor: SchemeColor.black,
                inputDecoratorIsFilled: false),
            useMaterial3: true,
            swapLegacyOnMaterial3: true),
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: const MainPage(),
      ),
    );
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
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(children: [
          SizedBox(
            height: hei - 20,
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
      ),
    ));
  }
}
