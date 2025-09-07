import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../login_page.dart';
import '../post_create_page.dart';
import '../provider/user_provider.dart';

class CustomBottomBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomBar(
      {super.key, required this.currentIndex, required this.onTap});

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
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(25)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
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
                      icon: Icon(Icons.home,
                          color: _selectedIndex == 0 ? Colors.blue : null)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                        widget.onTap(_selectedIndex);
                      },
                      icon: Icon(Icons.search,
                          color: _selectedIndex == 1 ? Colors.blue : null))
                ],
              ),
            ),
            SizedBox(
                width: (MediaQuery.sizeOf(context).width / 3) - 20,
                child: Center(
                  child: Container(
                    width: 60,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10)),
                    child: IconButton(
                        onPressed: () {
                          final isLogin = context.read<UserProvider>().isLogged??false;
                          if(!isLogin) {
                            Get.defaultDialog(
                              title: "로그인이 필요해요",
                              middleText: "로그인 하시겠습니까?",
                              textConfirm: "로그인",
                              textCancel: "확인",
                              onConfirm: () {
                                Get.back();
                                Get.to(() => LoginPage());
                              },
                              onCancel: () => Get.back(),
                            );
                            return;
                          }
                          Get.to(() => PostCreatePage());
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
                      icon: Icon(Icons.person,
                          color: _selectedIndex == 2 ? Colors.blue : null)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 3;
                        });
                        widget.onTap(_selectedIndex);
                      },
                      icon: Icon(Symbols.crown,
                          weight: 600,
                          fill: 1,
                          color: _selectedIndex == 3 ? Colors.amber : null))
                ],
              ),
            )
          ],
        ));
  }
}
