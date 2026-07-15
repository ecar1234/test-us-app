import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/recruit_post_bloc/recruit_post_bloc.dart';
import 'package:test_us_app/presentation/components/alerts/two_button_confirm_alert.dart';

import '../bloc/post_blocs/recruit_post_bloc/recruit_post_state.dart';
import '../pages/auth/login_page.dart';
import '../provider/user_provider.dart';

class CustomBottomBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Function() onRecruit;
  final Function() onPromotion;

  const CustomBottomBar({super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onRecruit,
    required this.onPromotion});

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  final menuList = ["Home", "Search", "Create", "MyPage", "purchase"];
  late int _selectedIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  @override
  void didUpdateWidget(covariant CustomBottomBar oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      setState(() {
        _selectedIndex = widget.currentIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        width: MediaQuery.sizeOf(context).width,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(25)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocListener<RecruitPostBloc, RecruitPostState>(
              listener: (context, state) {
                // note: BlocListener 의 상용 목적이 무엇???
                // if (state.state == RecruitPostLoadState.recruitPostsLoadCompletedState) {
                //   context.read<RecruitPostProvider>().getPostPagination(state.posts!, state.page);
                // }
              },
              child: SizedBox(
                width: (MediaQuery.sizeOf(context).width / 3) - 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 0;
                          });
                          widget.onTap(_selectedIndex);
                        },
                        icon: Icon(_selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                            color: _selectedIndex == 0 ? Theme.of(context).colorScheme.primary : null)),
                    IconButton(
                        onPressed: () async {
                          // context.read<RecruitPostBloc>().add(RequestRecruitmentPaginationEvent(1, 20));
                          setState(() {
                            _selectedIndex = 1;
                          });
                          widget.onTap(_selectedIndex);
                        },
                        icon: Icon(_selectedIndex == 1 ? Icons.search : Icons.search_outlined,
                            color: _selectedIndex == 1 ? Theme.of(context).colorScheme.primary : null)),
                  ],
                ),
              ),
            ),
            SizedBox(
                width: (MediaQuery.sizeOf(context).width / 3) - 20,
                child: Center(
                  child: Container(
                    width: 60,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(10)),
                    child: PopupMenuButton(
                        offset: Offset(-30, -100),
                        itemBuilder: (context) {
                          return const [
                            PopupMenuItem(
                                value: 0,
                                height: 40,
                                child: Center(
                                    child:
                                        Text('테스터 모집', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)))),
                            PopupMenuItem(
                                value: 1,
                                height: 40,
                                child: Center(
                                  child: Text('서비스 홍보', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                )),
                          ];
                        },
                        onSelected: (value) {
                          final isLogin = context.read<UserProvider>().isLogged ?? false;
                          if (!isLogin) {
                            showDialog(context: context, builder: (context) =>
                                TwoButtonConfirmAlert(
                                    width: 350,
                                    mainContent: '로그인이 필요합니다.',
                                    mainContentSize: 18,
                                    confirmButtonName: '로그인',
                                    cancelButtonName: '확인',
                                    onPressedConfirm: () {
                                      Navigator.pop(context);
                                      Get.to(() => const LoginPage());
                                    },
                                    onPressedCancel: () {
                                      Navigator.pop(context);
                                    }));
                            return;
                          }

                          if (value == 0) {
                            widget.onRecruit();
                          } else if (value == 1) {
                            widget.onPromotion();
                          }
                          // Get.to(() => RecruitPostCreatePage)
                        },
                        icon: Icon(Icons.add, color: Colors.white)),
                  ),
                )),
            SizedBox(
              width: (MediaQuery.sizeOf(context).width / 3) - 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 2;
                        });
                        widget.onTap(_selectedIndex);
                      },
                      icon: Icon(_selectedIndex == 2 ? Icons.person : Icons.person_outlined,
                          color: _selectedIndex == 2 ? Theme.of(context).colorScheme.primary : null)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 3;
                        });
                        widget.onTap(_selectedIndex);
                      },
                      icon: Icon(Symbols.crown, weight: 600, fill: 1, color: _selectedIndex == 3 ? Colors.amber : null))
                ],
              ),
            )
          ],
        ));
  }
}
