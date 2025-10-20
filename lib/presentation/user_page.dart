import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';
import 'package:test_us_app/presentation/login_page.dart';
import 'package:test_us_app/presentation/my_pages/my_recruitment_page.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/services/common_height_provider.dart';

import 'components/login_dialogs.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<String> menu = ['메시지 관리', '팔로우 관리', '테스터 모집 관리', '테스트 신청 관리', '나의 서비스 관리'];

  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei!;
    // final user = context.watch<UserProvider>().user!;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("마이페이지"),
          ),
          body: Container(
            // height: hei,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue.shade50, Colors.white, Colors.white, Colors.white])),
            child: Column(
              children: [
                //image section
                Selector<UserProvider, UserEntity>(
                  selector: (context, provider) => provider.user ?? UserEntity(),
                  builder: (context, user, child) => Container(
                      height: hei * 0.15,
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                          ),
                          const Gap(20),
                          SizedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                user.id == null
                                    ? SizedBox(
                                        child: TextButton.icon(
                                          onPressed: () {
                                            Get.to(() => const LoginPage());
                                          },
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                          ),
                                          label: Text(
                                            '로그인 하러가기',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          icon: Icon(Icons.arrow_forward_ios_sharp),
                                          iconAlignment: IconAlignment.end,
                                        ),
                                      )
                                    : SizedBox(
                                        child: TextButton.icon(
                                          onPressed: () {},
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                          ),
                                          label: Text(
                                            '${user.nickname}',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          icon: Icon(Icons.arrow_forward_ios_sharp),
                                          iconAlignment: IconAlignment.end,
                                        ),
                                      ),
                                SizedBox(
                                  child: Text(user.id == null ? 'Guest' : '${user.email}'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
                const Gap(20),
                // info section
                Container(
                    height: hei * 0.15,
                    width: MediaQuery.sizeOf(context).width,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    // decoration: BoxDecoration(
                    //   border: Border.all(),
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                    child: LayoutBuilder(
                      builder: (context, constraints) => Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              // border: Border.all(),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // 테스트 완료 서비스
                              SizedBox(
                                  width: (constraints.maxWidth * 0.3) - 12,
                                  // decoration: BoxDecoration(
                                  //   border: Border.all()
                                  // ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        child: Icon(
                                          Symbols.check_circle,
                                          color: Colors.blue.shade300,
                                          size: 25,
                                        ),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          "0",
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          "테스트 모집",
                                          style: TextStyle(color: Colors.grey.shade500),
                                        ),
                                      ),
                                    ],
                                  )),
                              SizedBox(width: 16, height: constraints.maxHeight - 40, child: const VerticalDivider()),
                              // 나의 홍보
                              SizedBox(
                                  width: (constraints.maxWidth * 0.3) - 12,
                                  // decoration: BoxDecoration(
                                  //   border: Border.all()
                                  // ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        child: Icon(
                                          Symbols.electrical_services,
                                          color: Colors.blue.shade300,
                                          size: 25,
                                        ),
                                      ),
                                      SizedBox(
                                          child: Text(
                                        "0",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                      )),
                                      SizedBox(
                                        child: Text(
                                          "나의 서비스",
                                          style: TextStyle(color: Colors.grey.shade500),
                                        ),
                                      ),
                                    ],
                                  )),
                              SizedBox(width: 16, height: constraints.maxHeight - 40, child: const VerticalDivider()),
                              // 나의 테스트 신청
                              SizedBox(
                                  width: (constraints.maxWidth * 0.3) - 12,
                                  // decoration: BoxDecoration(
                                  //   border: Border.all()
                                  // ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        child: Icon(
                                          Symbols.crop_free,
                                          color: Colors.blue.shade300,
                                          size: 25,
                                        ),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          "0",
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      SizedBox(
                                          child: Text(
                                        "진행중",
                                        style: TextStyle(color: Colors.grey.shade500),
                                      )),
                                    ],
                                  )),
                            ],
                          )),
                    )),
                const Gap(20),
                // menu section
                Container(
                    // height: (menu.length * 40) + 50,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    // decoration: BoxDecoration(
                    //   border: Border.all(),
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                    child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            // border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ]),
                        child: Selector<UserProvider, bool>(
                          selector: (context ,provider) => provider.isLogged ?? false,
                          builder:(context, isLogged, child) =>  ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, idx) {
                              return GestureDetector(
                                onTap: (){
                                  isLogged  ? _pageNavigator(idx) :
                                  showDialog(context: context, builder: (context) => const LoginDialog());
                                },
                                child: SizedBox(
                                    height: 40,
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(child: Icon(_getIcon(idx))),
                                        const Gap(10),
                                        SizedBox(
                                          width: (MediaQuery.sizeOf(context).width - 80) * 0.85,
                                          child: Text(
                                            menu[idx],
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    )),
                              );
                            },
                            separatorBuilder: (context, idx) {
                              return Divider(
                                color: Colors.grey.shade100,
                              );
                            },
                            itemCount: menu.length,
                          ),
                        )))
              ],
            ),
          )),
    );
  }

  IconData _getIcon(int idx) {
    switch (idx) {
      case 0:
        return Symbols.message;
      case 1:
        return Symbols.person;
      case 2:
        return Symbols.electrical_services;
      case 3:
        return Symbols.crop_free;
      case 4:
        return Symbols.linked_services;
      default:
        return Symbols.design_services;
    }
  }

  void _pageNavigator(int idx){
    switch (idx) {
      case 0:
        debugPrint(menu[idx]);
        break;
      case 1:
        debugPrint(menu[idx]);
        break;
      case 2:
        Get.to(() => const MyRecruitmentPage());
        break;
      case 3:
        debugPrint(menu[idx]);
        break;
      case 4:
        debugPrint(menu[idx]);
        break;
      default:
    }
  }
}
