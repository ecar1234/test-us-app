import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/presentation/pages/my_pages/reviews/user_review_page/recruit_post_review_page.dart';
import 'package:test_us_app/presentation/pages/my_pages/reviews/user_review_page/user_tester_review_page.dart';

import '../../../../../services/theme_provider.dart';

class UserReviewMainPage extends StatefulWidget {
  const UserReviewMainPage({super.key});

  @override
  State<UserReviewMainPage> createState() => _UserReviewMainPageState();
}

class _UserReviewMainPageState extends State<UserReviewMainPage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.read<ThemeProvider>().isDarkMode;
    return DefaultTabController(
      length: 2,
      child: Container(
        key: ValueKey(2),
        alignment: Alignment.center,
        // padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TabBar(tabs: [
              Tab(text: '테스터 리뷰',),
              Tab(text: '서비스 리뷰',)
            ]),
            Expanded(
              child: TabBarView(children: [
                UserTesterReviewPage(),
                RecruitPostReviewPage()
              ]),
            )
          ],
        ),
      ),
    );
  }
}
