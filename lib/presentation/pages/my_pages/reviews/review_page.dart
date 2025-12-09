import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:test_us_app/presentation/bloc/review_bloc/review_state.dart';
import 'package:test_us_app/presentation/pages/my_pages/reviews/application_post_review/service_review_main_page.dart';
import 'package:test_us_app/presentation/pages/my_pages/reviews/tester_review/tester_review_main_page.dart';
import 'package:test_us_app/presentation/pages/my_pages/reviews/user_review_page/user_review_main_page.dart';
import 'package:test_us_app/presentation/provider/review_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';

import '../../../../services/common_height_provider.dart';
import '../../../../services/theme_provider.dart';
import '../../../bloc/review_bloc/review_bloc.dart';
import '../../../bloc/review_bloc/review_event.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final List<bool> _selected = [true, false, false];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final token = context.read<UserProvider>().token!;
    final userId = context.read<UserProvider>().user!.id!;
    context.read<ReviewBloc>().add(RequestUserReviewEvent(token, userId));
  }
  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei!;
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("리뷰 관리"),
        ),
        body: BlocListener<ReviewBloc, ReviewState>(
          listener: (context, state){
            if(state is GetUserReviewDataCompletedState){
              context.read<ReviewProvider>().setUserReviews(state.reviews);
            }
          },
          child: SizedBox(
              height: hei,
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _toggleSection(),
                  const Gap(20),
                  Expanded(
                      child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _selected[0]
                              ? TesterReviewMainPage()
                              : (_selected[1] ? ServiceReviewMainPage() : UserReviewMainPage())))
                ],
              )),
        ),
      ),
    );
  }

  Widget _toggleSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ToggleButtons(
          onPressed: (int idx) {
            setState(() {
              for (int i = 0; i < _selected.length; i++) {
                _selected[i] = i == idx;
              }
            });
          },
          direction: Axis.horizontal,
          constraints: const BoxConstraints(minHeight: 40.0, minWidth: 80.0),
          selectedBorderColor: Color(0xFFC96646),
          borderColor: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(10),
          selectedColor: Colors.white,
          fillColor: Color(0xFFC96646).withAlpha(125),
          color: Color(0xFFC96646),
          isSelected: _selected,
          children: [
            Text(
              "테스터 리뷰",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            Text(
              "서비스 리뷰",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            Text(
              "나의 리뷰",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            )
          ]),
    );
  }
}
