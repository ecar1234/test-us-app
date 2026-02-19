import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/domain/entities/application_entity.dart';
import 'package:test_us_app/domain/entities/promotion_post_entity.dart';
import 'package:test_us_app/domain/entities/recruit_post_entity.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';
import 'package:test_us_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:test_us_app/presentation/pages/auth/login_page.dart';
import 'package:test_us_app/presentation/pages/message/message_main_page.dart';
import 'package:test_us_app/presentation/pages/my_pages/application/my_applications_page.dart';
import 'package:test_us_app/presentation/pages/my_pages/user_info/user_info_page.dart';
import 'package:test_us_app/presentation/provider/application_provider.dart';
import 'package:test_us_app/presentation/provider/firebase_messaging_provider.dart';
import 'package:test_us_app/presentation/provider/post_provider/base_post_provider.dart';
import 'package:test_us_app/presentation/provider/socket_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:test_us_app/services/theme_provider.dart';

import '../../../data/models/application/application_model.dart';
import '../../../data/models/post/recruit_post_model.dart';
import '../../../data/models/user/user_model.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/auth_bloc/auth_event.dart';
import '../../bloc/auth_bloc/auth_state.dart';
import '../../bloc/user_bloc/user_event.dart';
import '../../components/login_dialogs.dart';
import '../my_pages/recruit/my_recruitment_page.dart';
import '../my_pages/promotion/my_promotion_page.dart';
import '../my_pages/reviews/review_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<String> menu = ['메시지 관리', '팔로우 관리', '테스터 모집 관리', '나의 테스터 신청', '나의 서비스 홍보', '리뷰 관리'];

  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei! - 60;
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    // final user = context.watch<UserProvider>().user!;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("마이페이지"),
          ),
          body: BlocListener<AuthBloc, AuthState>(
            listener: (context, state){

            },
            listenWhen: (prev, current) => current.state == UserAuthState.authLoginCompletedState
                || current.state == UserAuthState.loginCompletedState,
            child: SizedBox(
              height: hei,
              // decoration: BoxDecoration(
              // gradient: LinearGradient(
              //     begin: Alignment.topCenter,
              //     end: Alignment.bottomCenter,
              //     colors: [Colors.blue.shade50, Colors.white, Colors.white, Colors.white])),
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
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: user.profileImg == null || user.profileImg!.url == null
                                  ? const AssetImage('assets/images/Generic avatar.png')
                                  : CachedNetworkImageProvider(user.profileImg!.url!),
                            ),
                            const Gap(20),
                            SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  user.id == null
                                      ? SizedBox(
                                    height: 30,
                                          child: TextButton.icon(
                                            onPressed: () {
                                              Get.to(() => const LoginPage());
                                            },
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                            ),
                                            label: Text(
                                              '로그인',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            icon: Icon(Icons.arrow_forward_ios_sharp),
                                            iconAlignment: IconAlignment.end,
                                          ),
                                        )
                                      : SizedBox(
                                    height: 30,
                                          child: TextButton.icon(
                                            onPressed: () {
                                              Get.to(() => UserInfoPage(user: user));
                                            },
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
                      child: LayoutBuilder(builder: (context, constraints) {
                        return Selector<UserProvider, bool>(
                          selector: (context, provider) => provider.isLogged ?? false,
                          builder: (context, isLogged, child) => Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  // border: Border.all(),
                                  borderRadius: BorderRadius.circular(10),
                                  color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                                  boxShadow: isDarkMode
                                      ? null
                                      : [
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
                                              color: const Color(0xffEE6C20),
                                              size: 25,
                                            ),
                                          ),
                                          Selector<BasePostProvider, List<RecruitPostEntity>>(
                                              selector: (context, provider) {
                                            List<RecruitPostEntity> posts = [];
                                            if (provider.userRecruitPosts != null) {
                                              if (provider.userRecruitPosts!.isEmpty) {
                                                return posts;
                                              }
                                              for (var post in provider.userRecruitPosts!) {
                                                if (post.status == PostStatus.active) {
                                                  posts.add(post);
                                                }
                                              }
                                            }
                                            return posts;
                                          }, builder: (context, posts, child) {
                                            return SizedBox(
                                              child: Text(
                                                isLogged ? '${posts.length}' : '0',
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                              ),
                                            );
                                          }),
                                          SizedBox(
                                            child: Text(
                                              "테스트 모집",
                                              style: TextStyle(color: Colors.grey.shade500),
                                            ),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                      width: 16, height: constraints.maxHeight - 40, child: const VerticalDivider()),
                                  // 나의 홍보
                                  SizedBox(
                                      width: (constraints.maxWidth * 0.3) - 12,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(
                                            child: Icon(
                                              Symbols.electrical_services,
                                              color: const Color(0xffEE6C20),
                                              size: 25,
                                            ),
                                          ),
                                          Selector<BasePostProvider, List<PromotionPostEntity>>(
                                            selector: (context, provider) {
                                              List<PromotionPostEntity> posts = [];
                                              if (provider.userPromotionPosts != null) {
                                                if (provider.userPromotionPosts!.isEmpty) {
                                                  return posts;
                                                }
                                                for (var post in provider.userPromotionPosts!) {
                                                  if (post.status == PostStatus.active) {
                                                    posts.add(post);
                                                  }
                                                }
                                              }
                                              return posts;
                                            },
                                            builder: (context, posts, child) {
                                              return SizedBox(
                                                  child: Text(
                                                isLogged ? '${posts.length}' : '0',
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                              ));
                                            },
                                          ),
                                          SizedBox(
                                            child: Text(
                                              "나의 서비스",
                                              style: TextStyle(color: Colors.grey.shade500),
                                            ),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                      width: 16, height: constraints.maxHeight - 40, child: const VerticalDivider()),
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
                                              color: const Color(0xffEE6C20),
                                              size: 25,
                                            ),
                                          ),
                                          Selector<ApplicationProvider, List<ApplicationEntity>>(
                                              selector: (context, provider) {
                                            List<ApplicationEntity> apps = [];
                                            if (provider.userApplications != null) {
                                              if (provider.userApplications!.isEmpty) {
                                                return apps;
                                              }
                                              for (var app in provider.userApplications!) {
                                                if (app.status != ApplicationStatus.cancel &&
                                                    app.status != ApplicationStatus.rejected) {
                                                  apps.add(app);
                                                }
                                              }
                                            }
                                            return apps;
                                          }, builder: (context, apps, child) {
                                            int length = 0;
                                            if (apps.isNotEmpty) {
                                              for (var app in apps) {
                                                if (app.status != ApplicationStatus.cancel &&
                                                    app.status != ApplicationStatus.rejected) {
                                                  length++;
                                                }
                                              }
                                            }
                                            return SizedBox(
                                              child: Text(
                                                isLogged ? '$length' : '0',
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                              ),
                                            );
                                          }),
                                          SizedBox(
                                              child: Text(
                                            "테스트 신청",
                                            style: TextStyle(color: Colors.grey.shade500),
                                          )),
                                        ],
                                      )),
                                ],
                              )),
                        );
                      })),
                  const Gap(20),
                  // menu section
                  Container(
                      height: hei * 0.45,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                              boxShadow: isDarkMode
                                  ? null
                                  : [
                                      BoxShadow(
                                        color: Colors.grey.shade200,
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ]),
                          child: Selector<UserProvider, bool>(
                            selector: (context, provider) => provider.isLogged ?? false,
                            builder: (context, isLogged, child) => ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, idx) {
                                return GestureDetector(
                                  onTap: () {
                                    isLogged
                                        ? _pageNavigator(context, idx)
                                        : showDialog(context: context, builder: (context) => const LoginDialog());
                                  },
                                  child: SizedBox(
                                      height: ((hei*0.45)-20-((menu.length-1)*16))/menu.length,
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
                          ))),
                  const Gap(40),
                  Expanded(
                    child: Selector<UserProvider, bool>(
                        selector: (context, provider) => provider.isLogged ?? false,
                        builder: (context, isLogged, child) {
                          if (isLogged) {
                            return Center(
                              child: SizedBox(
                                height: 50,
                                width: MediaQuery.sizeOf(context).width * 0.7,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      await showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            child: Container(
                                                height: 200,
                                                width: MediaQuery.sizeOf(context).width,
                                                padding: EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  // color: Colors.white
                                                ),
                                                child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Text("로그아웃", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                                      Text(
                                                        '로그아웃 하시나요?',
                                                        style: TextStyle(fontSize: 14),
                                                      ),
                                                      const Gap(20),
                                                      LayoutBuilder(
                                                        builder: (context, constraints) {
                                                          return Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Flexible(
                                                                flex: 3,
                                                                child: SizedBox(
                                                                  width: constraints.maxWidth * 0.3,
                                                                  child: OutlinedButton(
                                                                      onPressed: () {
                                                                        Get.back();
                                                                      },
                                                                      style: OutlinedButton.styleFrom(
                                                                        side: BorderSide(color: Theme.of(context).colorScheme.primary),
                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                      ),
                                                                      child: Text('취소')),
                                                                ),
                                                              ),
                                                              const Gap(10),
                                                              Flexible(
                                                                flex: 7,
                                                                child: SizedBox(
                                                                  width: constraints.maxWidth * 0.7,
                                                                  child: ElevatedButton(
                                                                      onPressed: () {
                                                                        Navigator.pop(context);
                                                                        final user = context.read<UserProvider>().user!;
                                                                        if (user.method! != AuthType.email) {
                                                                          // final token = context.read<AuthBloc>().state.token!;
                                                                          // final userId = context.read<AuthBloc>().state.user!.id;
                                                                          // final messagingToken = context.read<FirebaseMessagingProvider>().token??'';
                                                                          // context
                                                                          //     .read<UserBloc>()
                                                                          //     .add(RemoveFirebaseTokenEvent(token, userId, messagingToken));
                                                                          context.read<AuthBloc>().add(LogoutEvent());
                                                                          context.read<SocketProvider>().disconnect();
                                                                        }
                                                                        context.read<UserProvider>().logout();
                                                                        context.read<BasePostProvider>().logout();
                                                                        context.read<ApplicationProvider>().logout();
                                                                        context.read<FirebaseMessagingProvider>().removeFirebaseToken();
                                                                        context.read<FirebaseMessagingProvider>().readAllNotification();
                                                                        // context.read<AuthBloc>().add(LogoutEvent());
                                                                      },
                                                                      style: OutlinedButton.styleFrom(
                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                      ),
                                                                      child: Text('확인')),
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        }
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          );
                                        }
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text("로그아웃", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                              ),
                            );
                          }
                          return SizedBox();
                        }),
                  )
                ],
              ),
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
      case 5:
        return Symbols.reviews;
      default:
        return Symbols.design_services;
    }
  }

  void _pageNavigator(BuildContext context, int idx) {
    switch (idx) {
      case 0:
        debugPrint(menu[idx]);
        Get.to(() => MessageMainPage());
        break;
      case 1:
        debugPrint(menu[idx]);
        break;
      case 2:
        debugPrint(menu[idx]);
        Get.to(() => const MyRecruitmentPage());
        break;
      case 3:
        debugPrint(menu[idx]);
        Get.to(() => MyApplicationsPage());
        break;
      case 4:
        debugPrint(menu[idx]);
        Get.to(() => const MyPromotionPage());
        break;
      case 5:
        debugPrint(menu[idx]);
        Get.to(() => ReviewPage());
        break;
      default:
    }
  }
}
