
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'package:test_us_app/presentation/pages/home/purchase_page.dart';
import 'package:test_us_app/presentation/pages/home/search_page.dart';
import 'package:test_us_app/presentation/pages/post/promotion_post_pages/promotion_post_create_page.dart';
import 'package:test_us_app/presentation/pages/post/tester_post_pages/recruit_post_create_page.dart';

import 'package:test_us_app/presentation/pages/home/user_page.dart';

import 'package:test_us_app/services/common_height_provider.dart';
import 'package:test_us_app/services/theme_provider.dart';

import '../components/custom_bottom_bar.dart';
import 'home/home_page.dart';

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
