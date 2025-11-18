import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/data/models/user/user_model.dart';
import 'package:test_us_app/domain/entities/promotion_post_entity.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/base_post_bloc/base_post_bloc.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/base_post_bloc/base_post_state.dart';
import 'package:test_us_app/presentation/pages/post/promotion_post_pages/promotion_post_detail_page.dart';
import 'package:test_us_app/presentation/pages/post/tester_post_pages/recruit_post_detail_page.dart';
import 'package:test_us_app/presentation/pages/post/post_main_page.dart';
import 'package:test_us_app/presentation/pages/setting_page.dart';
import 'package:test_us_app/presentation/provider/post_provider/base_post_provider.dart';

import 'package:test_us_app/presentation/provider/post_provider/recruit_post_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';

import '../../data/sharedPreferences/auth_preference.dart';
import '../../domain/entities/recruit_post_entity.dart';
import '../../services/common_height_provider.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_event.dart';
import '../bloc/post_blocs/promotion_bloc/promotion_bloc.dart';
import '../bloc/post_blocs/promotion_bloc/promotion_event.dart';
import '../bloc/post_blocs/recruit_post_bloc/recruit_post_bloc.dart';
import '../bloc/post_blocs/recruit_post_bloc/recruit_post_event.dart';
import '../provider/application_provider.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final Function(int) onTap;

  const HomePage({super.key, required this.onTap});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pref = AuthPreference.instance;

  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei ?? MediaQuery.sizeOf(context).height - 120;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Testus', style: TextStyle(fontWeight: FontWeight.bold)),
            // 추후 로고 이미지로 변경
            actions: [
              Selector<UserProvider, bool>(
                selector: (context, provider) => provider.isLogged ?? false,
                builder: (context, isLogin, child) => !isLogin
                    ? IconButton(
                        onPressed: () {
                          Get.to(() => LoginPage());
                        },
                        icon: const Icon(Icons.login))
                    : IconButton(
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
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    final user = context.read<UserProvider>().user!;
                                    if(user.method! != AuthType.email){
                                      context.read<AuthBloc>().add(RequestAuthLogoutEvent(user));
                                    }
                                    context.read<UserProvider>().logout();
                                    context.read<BasePostProvider>().logout();
                                    context.read<ApplicationProvider>().logout();
                                    context.read<AuthBloc>().add(LogoutEvent());
                                  },
                                  child: const Text('확인')),
                            ],
                          );
                          // context.read<AuthBloc>().add(LogoutEvent(context));
                        },
                        icon: const Icon(Icons.logout)),
              ),
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
                            _mainButtonSection(context),
                            const Gap(20),
                            _favoritePostList(context),
                            const Gap(20),
                            _testerList(context),
                            const Gap(20),
                            _promotionList(context),
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
  }

  Widget _mainButtonSection(BuildContext context) {
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
              child: FilledButton(
                  onPressed: () {
                    Get.to(() => PostMainPage(type: 'recruit'));
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: Center(
                    child: Text("테스터 모집"),
                  ))),
          const Gap(10),
          SizedBox(
              height: 80,
              width: (MediaQuery.sizeOf(context).width - 80) / 4,
              child: FilledButton(
                  onPressed: () {
                    Get.to(() => PostMainPage(type: 'promotion'));
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: Center(
                    child: Text("서비스 홍보"),
                  ))),
          const Gap(10),
          SizedBox(
              height: 80,
              width: (MediaQuery.sizeOf(context).width - 80) / 4,
              child: FilledButton(
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
              child: FilledButton(
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

  Widget _favoritePostList(BuildContext context) {
    return Selector<BasePostProvider, List<dynamic>>(
        selector: (context, provider) => provider.favoritePost ?? [],
        builder: (context, favoritePost, child) {
          if (favoritePost.isNotEmpty) {
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
            SizedBox(
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
                            onTap: () async {
                              favoritePost[idx].domain == null
                                  ? Get.to(() => RecruitPostDetailPage(postId: favoritePost[idx].id!))
                                  : Get.to(() => PromotionPostDetailPage(postId: favoritePost[idx].id!));
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
                                          // color: Colors.green,
                                          border: favoritePost[idx].images!.isEmpty ? Border.all() : null,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: favoritePost[idx].images!.isEmpty
                                            ? SizedBox(
                                                child: Center(
                                                  child: Text('이미지가 없습니다.'),
                                                ),
                                              )
                                            : ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: CachedNetworkImage(
                                                  imageUrl: favoritePost[idx].images![0].url ?? '',
                                                  fit: BoxFit.cover,
                                                  progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                                      child: SizedBox(
                                                          height: 50,
                                                          width: 50,
                                                          child: CircularProgressIndicator(
                                                              value: downloadProgress.progress))),
                                                ),
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
          ]);}
          return SizedBox();
        });
  }

  Widget _testerList(BuildContext context) {
    return BlocBuilder<BasePostBloc, BasePostState>(builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('테스터 모집', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: () async {
                      // await context.read<RecruitPostProvider>().getPostPagination(page: 1);
                      context.read<RecruitPostBloc>().add(RequestRecruitmentPaginationEvent(1, 10));
                      // widget.onTap(1);
                      Get.to(() => PostMainPage(type: 'recruit'));
                    },
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: Text("전체 보기", ))
              ],
            ),
          ),
          if (state.state == BasePostLoadState.initPostDataLoadingState)
            SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            Selector<BasePostProvider, List<RecruitPostEntity>>(
              selector: (context, provider) => provider.recruitPosts ?? [],
              builder: (context, posts, child) => SizedBox(
                  height: 230,
                  width: MediaQuery.sizeOf(context).width,
                  // padding: EdgeInsets.all(10),
                  // decoration: BoxDecoration(
                  //     border: Border.all()
                  // ),
                  child: posts.isEmpty
                      ? const Center(child: Text("테스터 모집이 아직 없습니다."))
                      : ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, idx) {
                            return GestureDetector(
                              onTap: () async {
                                Get.to(() => RecruitPostDetailPage(postId: posts[idx].id!));
                              },
                              child: SizedBox(
                                height: 230,
                                width: 160,
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
                                            border: posts[idx].images!.isEmpty ? Border.all() : null,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: posts[idx].images!.isEmpty
                                              ? SizedBox(
                                                  child: Center(
                                                    child: Text('이미지가 없습니다.'),
                                                  ),
                                                )
                                              : ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: Image.network(
                                                    posts[idx].images![0].url ?? '',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                        );
                                      }),
                                    ),
                                    const Gap(10),
                                    SizedBox(
                                        child: Text(
                                      "${posts[idx].title}",
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                                      maxLines: 2,
                                    )),
                                    const Gap(5),
                                    if (posts[idx].platform!.length > 1)
                                      SizedBox(
                                          child: Row(
                                        children: [
                                          Text(
                                            posts[idx].platform![0],
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.grey.shade600,
                                                overflow: TextOverflow.ellipsis),
                                          ),
                                          const Gap(10),
                                          Text(
                                            posts[idx].platform![1],
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.grey.shade600,
                                                overflow: TextOverflow.ellipsis),
                                          ),
                                        ],
                                      ))
                                    else
                                      SizedBox(
                                        child: Text(
                                          posts[idx].platform![0],
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey.shade600,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                    const Gap(5),
                                    SizedBox(
                                        child: Text(
                                      posts[idx].author!.nickname ?? context.read<UserProvider>().user!.nickname ?? '',
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
                          itemCount: posts.length > 10 ? 10 : posts.length)),
            ),
        ],
      );
    });
  }

  Widget _promotionList(BuildContext context) {
    return BlocBuilder<BasePostBloc, BasePostState>(builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('서비스 홍보', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: () async {
                      // await context.read<RecruitPostProvider>().getPostPagination(page: 1);
                      // context.read<PromotionBloc>().add(RequestPromotionPaginationEvent(1, 10));
                      Get.to(() => PostMainPage(type: 'promotion'));
                      // widget.onTap(1);
                    },
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: Text("전체 보기"))
              ],
            ),
          ),
          if (state.state == BasePostLoadState.initPostDataLoadingState)
            SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            Selector<BasePostProvider, List<PromotionPostEntity>>(
              selector: (context, provider) => provider.promotionPosts ?? [],
              builder: (context, posts, child) => SizedBox(
                  height: 230,
                  width: MediaQuery.sizeOf(context).width,
                  // padding: EdgeInsets.all(10),
                  // decoration: BoxDecoration(
                  //     border: Border.all()
                  // ),
                  child: posts.isEmpty
                      ? const Center(child: Text("서비스 홍보가 아직 없습니다."))
                      : ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, idx) {
                            return GestureDetector(
                              onTap: () async {
                                Get.to(() => PromotionPostDetailPage(postId: posts[idx].id!));
                              },
                              child: SizedBox(
                                height: 230,
                                width: 160,
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
                                            border: posts[idx].images!.isEmpty ? Border.all() : null,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: posts[idx].images!.isEmpty
                                              ? SizedBox(
                                                  child: Center(
                                                    child: Text('이미지가 없습니다.'),
                                                  ),
                                                )
                                              : ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: Image.network(
                                                    posts[idx].images![0].url ?? '',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                        );
                                      }),
                                    ),
                                    const Gap(10),
                                    SizedBox(
                                        child: Text(
                                      "${posts[idx].title}",
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                                      maxLines: 2,
                                    )),
                                    const Gap(5),
                                    if (posts[idx].platform!.length > 1)
                                      SizedBox(
                                          child: Row(
                                        children: [
                                          Text(
                                            posts[idx].platform![0],
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.grey.shade600,
                                                overflow: TextOverflow.ellipsis),
                                          ),
                                          const Gap(10),
                                          Text(
                                            posts[idx].platform![1],
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.grey.shade600,
                                                overflow: TextOverflow.ellipsis),
                                          ),
                                        ],
                                      ))
                                    else
                                      SizedBox(
                                        child: Text(
                                          posts[idx].platform![0],
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey.shade600,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                    const Gap(5),
                                    SizedBox(
                                        child: Text(
                                      posts[idx].author!.nickname ?? context.read<UserProvider>().user!.nickname ?? '',
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
                          itemCount: posts.length > 10 ? 10 : posts.length)),
            ),
        ],
      );
    });
  }
}
