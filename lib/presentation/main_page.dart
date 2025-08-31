import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:test_us_app/presentation/bloc/auth_bloc/auth_event.dart';
import 'package:test_us_app/presentation/post_tester_page.dart';
import 'package:test_us_app/presentation/purchase_page.dart';
import 'package:test_us_app/presentation/user_page.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/auth_bloc/auth_bloc.dart';
import 'bloc/data_bloc/data_bloc.dart';
import 'bloc/data_bloc/data_event.dart';
import 'bloc/data_bloc/data_state.dart';
import 'components/custom_bottom_bar.dart';
import 'home_page.dart';

class MetaDataSetting extends StatefulWidget {
  const MetaDataSetting({super.key});

  @override
  State<MetaDataSetting> createState() => _MetaDataSettingState();
}

class _MetaDataSettingState extends State<MetaDataSetting> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() => _loadSetting());
  }

  Future<void> _loadSetting() async {
    GetIt.I.get<ResponsiveHeightProvider>().setHeight(context);
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<DataBloc, DataState>(builder: (context, state) {
      if (state.state == DataLoadState.serviceStartState) {
        context.read<DataBloc>().add(RequestInitDataEvent(context));
        context.read<AuthBloc>().add(TokenCheckEvent());
      }
      return GetMaterialApp(
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
      );
    });
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainState();
}

class _MainState extends State<MainPage> {
  bool isLogin = false;

  int _currentIdx = 0;

  late List<Widget>_pageList = [];

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
      const PostTesterPage(),
      const UserPage(),
      const PurchasePage(),
    ];
  }
  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei ??
        MediaQuery.sizeOf(context).height - 120;
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
