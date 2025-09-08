import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/presentation/bloc/app_bloc/app_event.dart';
import 'package:test_us_app/presentation/post_detail_page.dart';
import 'package:test_us_app/presentation/post_tester_page.dart';
import 'package:test_us_app/presentation/provider/post_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/presentation/setting_page.dart';

import '../domain/entities/post_entity.dart';
import '../services/common_height_provider.dart';
import 'bloc/app_bloc/app_bloc.dart';
import 'bloc/auth_bloc/auth_bloc.dart';
import 'bloc/auth_bloc/auth_event.dart';
import 'bloc/auth_bloc/auth_state.dart';
import 'bloc/data_bloc/data_bloc.dart';
import 'bloc/data_bloc/data_event.dart';
import 'bloc/data_bloc/data_state.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final Function(int) onTap;

  const HomePage({super.key, required this.onTap});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei ?? MediaQuery.sizeOf(context).height - 120;
    final isLogin = context.watch<UserProvider>().isLogged!;
    return BlocBuilder<DataBloc, DataState>(
      builder: (context, state) {
        if (state.state == DataLoadState.postCreateCompletedState) {
          context.read<DataBloc>().add(RequestCompleteEvent());
        }
        return SafeArea(
          child: Scaffold(
              appBar: AppBar(
                title: const Text('Testus', style: TextStyle(fontWeight: FontWeight.bold)),
                // 추후 로고 이미지로 변경
                actions: [
                  if (!isLogin)
                    IconButton(
                        onPressed: () {
                          Get.to(() => LoginPage());
                        },
                        icon: const Icon(Icons.login))
                  else
                    IconButton(
                        onPressed: () {
                          Get.defaultDialog(
                            title: '로그아웃',
                            middleText: '로그아웃 하시겠습니까?',
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('취소')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    context.read<AuthBloc>().add(LogoutEvent(context));
                                  },
                                  child: const Text('확인')),
                            ],
                          );
                          // context.read<AuthBloc>().add(LogoutEvent(context));
                        },
                        icon: const Icon(Icons.logout)),
                  IconButton(
                      onPressed: () {
                        Get.to(() => SettingPage());
                      },
                      icon: const Icon(Icons.settings)),
                ],
              ),
              body: SizedBox(
                  height: hei,
                  width: MediaQuery.sizeOf(context).width,
                  // padding: EdgeInsets.only(top: 10),
                  // decoration: BoxDecoration(
                  //   border: Border.all()
                  // ),
                  child: SizedBox(
                    height: hei - 20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const Gap(10),
                                _mainButtonSection(),
                                const Gap(20),
                                _favoritePostList(),
                                const Gap(20),
                                _testerList(),
                                // const Gap(20),
                                // _webServiceList(),
                              ],
                            ),
                          ),
                        ),
                        // CustomBottomBar(
                        //   currentIndex: 0,
                        //   onTap: (idx) {
                        //     setState(() {
                        //       _currentIdx = idx;
                        //     });
                        //   },
                        // )
                      ],
                    ),
                  ))),
        );
      },
    );
  }

  Widget _mainButtonSection() {
    return SizedBox(
      height: 100,
      width: MediaQuery.sizeOf(context).width,
      // decoration: BoxDecoration(
      //   border: Border.all()
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 80,
              width: (MediaQuery.sizeOf(context).width - 80) / 4,
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: Center(
                    child: Text("테스터 모집"),
                  ))),
          const Gap(10),
          SizedBox(
              height: 80,
              width: (MediaQuery.sizeOf(context).width - 80) / 4,
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: Center(
                    child: Text("서비스 홍보"),
                  ))),
          const Gap(10),
          SizedBox(
              height: 80,
              width: (MediaQuery.sizeOf(context).width - 80) / 4,
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: Center(
                    child: Text("지원 현황"),
                  ))),
          const Gap(10),
          SizedBox(
              height: 80,
              width: (MediaQuery.sizeOf(context).width - 80) / 4,
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: Center(
                    child: Text("커뮤니티"),
                  ))),
        ],
      ),
    );
  }

  Widget _favoritePostList() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Icon(Icons.local_fire_department, color: Colors.red),
            Text("HOT", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      Selector<PostProvider, List<PostEntity>>(
        selector: (context, provider) => provider.favoritePost ?? [],
        builder: (context, favoritePost, child) => SizedBox(
            height: 220,
            width: MediaQuery.sizeOf(context).width,
            // padding: EdgeInsets.all(10),
            // decoration: BoxDecoration(
            //     border: Border.all()
            // ),
            child: favoritePost.isEmpty
                ? const Center(child: Text("아직 HOT 게시글이 없습니다."))
                : ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 20),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, idx) {
                      return GestureDetector(
                        onTap: () {
                          final token = context.read<UserProvider>().token ?? "";
                          context.read<DataBloc>().add(GetPostDetailEvent(context, favoritePost[idx].id!, token));
                          Get.to(() => PostDetailPage(post: favoritePost[idx]));
                        },
                        child: SizedBox(
                          height: 210,
                          width: 160,
                          // decoration: BoxDecoration(
                          //   color: Theme.of(context).colorScheme.surface,
                          // ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: 210, maxWidth: 180),
                                child: LayoutBuilder(builder: (context, constraints) {
                                  return Container(
                                    width: constraints.maxWidth,
                                    height: constraints.maxHeight * 0.55,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  );
                                }),
                              ),
                              const Gap(10),
                              SizedBox(
                                  child: Text(
                                "${favoritePost[idx].title}",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                                maxLines: 2,
                              )),
                              const Gap(10),
                              SizedBox(
                                  child: Text(
                                "${favoritePost[idx].author!.nickname}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey.shade600,
                                    overflow: TextOverflow.ellipsis),
                                maxLines: 1,
                              )),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, idx) => const Gap(10),
                    itemCount: favoritePost.length)),
      )
    ]);
  }

  Widget _testerList() {
    return BlocBuilder<DataBloc, DataState>(
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('테스터 모집', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: () {
                      context.read<DataBloc>().add(RequestPostDataEvent(context, 1));
                      widget.onTap(1);
                    },
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: Text("전체 보기"))
              ],
            ),
          ),
          Selector<PostProvider, List<PostEntity>>(
            selector: (context, provider) => provider.posts ?? [],
            builder: (context, post, child) => SizedBox(
                height: 220,
                width: MediaQuery.sizeOf(context).width,
                // padding: EdgeInsets.all(10),
                // decoration: BoxDecoration(
                //     border: Border.all()
                // ),
                child: post.isEmpty
                    ? const Center(child: Text("테스터 모집이 아직 없습니다."))
                    : ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(left: 20),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, idx) {
                          return GestureDetector(
                            onTap: () {
                              final token = context.read<UserProvider>().token ?? "";
                              context.read<DataBloc>().add(GetPostDetailEvent(context, post[idx].id!, token));
                              Get.to(() => PostDetailPage(post: post[idx]));
                            },
                            child: Container(
                              height: 210,
                              width: 160,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(maxHeight: 210, maxWidth: 180),
                                    child: LayoutBuilder(builder: (context, constraints) {
                                      return Container(
                                        width: constraints.maxWidth,
                                        height: constraints.maxHeight * 0.55,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      );
                                    }),
                                  ),
                                  const Gap(10),
                                  SizedBox(
                                      child: Text(
                                    "${post[idx].title}",
                                    style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                                    maxLines: 2,
                                  )),
                                  const Gap(10),
                                  SizedBox(
                                      child: Text(
                                    "${post[idx].author!.nickname}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey.shade600,
                                        overflow: TextOverflow.ellipsis),
                                    maxLines: 1,
                                  )),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, idx) => const Gap(10),
                        itemCount: post.length)),
          ),
        ],
      ),
    );
  }

// Widget _webServiceList() {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Container(
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('웹 서비스',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             TextButton(
//                 onPressed: () {
//                   // context
//                   //     .read<DataBloc>()
//                   //     .add(RequestPostDataEvent(context, 'web', 1));
//                   Get.to(() => const PostTesterPage());
//                 },
//                 style: TextButton.styleFrom(padding: EdgeInsets.zero),
//                 child: Text("더보기"))
//           ],
//         ),
//       ),
//       Selector<PostProvider, List<PostEntity>>(
//         selector: (context, provider) => provider.posts ?? [],
//         builder: (context, webPost, child) => SizedBox(
//             height: 150,
//             width: MediaQuery.sizeOf(context).width,
//             // padding: EdgeInsets.all(10),
//             // decoration: BoxDecoration(
//             //     border: Border.all()
//             // ),
//             child: webPost.isEmpty
//                 ? const Center(child: Text("웹 서비스 게시글이 아직 없습니다."))
//                 : ListView.separated(
//                     shrinkWrap: true,
//                     padding: EdgeInsets.only(left: 20),
//                     scrollDirection: Axis.horizontal,
//                     itemBuilder: (context, idx) {
//                       return Container(
//                         height: 120,
//                         width: 150,
//                         decoration: BoxDecoration(
//                           color: Theme.of(context).colorScheme.surface,
//                         ),
//                         child: Text("$idx"),
//                       );
//                     },
//                     separatorBuilder: (context, idx) => const Gap(10),
//                     itemCount: 4)),
//       ),
//     ],
//   );
// }
}
