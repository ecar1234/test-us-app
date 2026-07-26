import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:test_us_app/data/models/application/application_model.dart';
import 'package:test_us_app/data/models/post/recruit_post_model.dart';
import 'package:test_us_app/domain/entities/firebase_messaging_entity.dart';
import 'package:test_us_app/domain/entities/promotion_post_entity.dart';
import 'package:test_us_app/presentation/bloc/auth_bloc/auth_event.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/base_post_bloc/base_post_bloc.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/base_post_bloc/base_post_state.dart';
import 'package:test_us_app/presentation/pages/post/promotion_post_pages/promotion_post_detail_page.dart';
import 'package:test_us_app/presentation/pages/post/tester_post_pages/recruit_post_detail_page.dart';
import 'package:test_us_app/presentation/pages/post/post_main_page.dart';
import 'package:test_us_app/presentation/pages/home/setting_page.dart';
import 'package:test_us_app/presentation/provider/firebase_messaging_provider.dart';
import 'package:test_us_app/presentation/provider/post_provider/base_post_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/utils/type_conversion_util.dart';

import '../../../data/models/user/user_model.dart';
import '../../../data/sharedPreferences/auth_preference.dart';
import '../../../domain/entities/recruit_post_entity.dart';
import '../../../services/common_height_provider.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/post_blocs/base_post_bloc/base_post_event.dart';
import '../../bloc/post_blocs/recruit_post_bloc/recruit_post_bloc.dart';
import '../../bloc/post_blocs/recruit_post_bloc/recruit_post_event.dart';
import '../../bloc/user_bloc/user_bloc.dart';
import '../../components/notifications_page.dart';
import '../auth/login_page.dart';

class HomePage extends StatefulWidget {
  final Function(int) onTap;

  const HomePage({super.key, required this.onTap});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pref = AuthPreference.instance;
  final TextEditingController _changeController = TextEditingController();

  // bool _isRefresh = false;
  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei ?? MediaQuery.sizeOf(context).height - 120;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('TESTUS', style: TextStyle(fontWeight: FontWeight.bold)),
            // 추후 로고 이미지로 변경
            actions: [
              if(kDebugMode)
                   Selector<UserProvider, bool>(
                     selector: (context, provider) => provider.isLogged ?? false,
                     builder:(context, isLogin, child) => ElevatedButton(
                         onPressed: isLogin ? () {
                           showDialog(
                               context: context,
                               builder: (context) {
                                 final nick = context.read<UserProvider>().user!.nickname;
                                 return Dialog(
                                   child: Container(
                                       height: 300,
                                       width: 300,
                                       padding: EdgeInsets.all(10),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         crossAxisAlignment: CrossAxisAlignment.center,
                                         children: [
                                           Text('current : $nick'),
                                           const Gap(20),
                                           DropdownMenu(
                                               controller: _changeController,
                                               initialSelection: nick,
                                               menuHeight: 200,
                                               dropdownMenuEntries: List.generate(11, (index) {
                                                 if (index == 0) {
                                                   return DropdownMenuEntry(value: 'master', label: 'master');
                                                 }
                                                 return DropdownMenuEntry(value: 'test$index', label: 'test$index');
                                               })),
                                           const Gap(20),
                                           SizedBox(
                                             height: 50,
                                             width: 100,
                                             child: ElevatedButton(
                                                 onPressed: ()async{
                                                   if(_changeController.text == nick){
                                                     Get.snackbar('알림', '아이디 같음');
                                                     return;
                                                   }
                                                   final email = nick == 'master'
                                                       ? 'master@master.com'
                                                       : '${_changeController.text}@test.com';
                                                   context.read<AuthBloc>().add(LogoutEvent());
                                                   context.read<AuthBloc>()
                                                       .add(EmailLoginEvent(email, 'qwer1234!'));
                                                   Get.back();
                                                   return;
                                                 },
                                               child: Text('교체'),
                                             )
                                           )
                                         ],
                                       )),
                                 );
                               });
                           return ;
                         } : null,
                         child: Text('Change')),
                   ),
              Selector<UserProvider, bool>(
                  selector: (context, provider) => provider.isLogged ?? false,
                  builder: (context, isLogin, child) => !isLogin
                      ? ElevatedButton(
                          onPressed: () {
                            Get.to(() => LoginPage());
                          },
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          child: Text('로그인', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)))
                      : Selector<FirebaseMessagingProvider, List<FirebaseMessagingEntity>>(
                          selector: (context, provider) => provider.notifications ?? [],
                          builder: (context, notifications, child) {
                            final count = notifications.where((e) => e.isRead == false).length;

                            return IconButton(
                              onPressed: () {
                                Get.to(() => NotificationsPage());
                              },
                              icon: Badge.count(
                                count: count,
                                isLabelVisible: count > 0,
                                child: Icon(Symbols.notifications, size: 30),
                              ),
                            );
                          })),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: IconButton(
                    onPressed: () {
                      Get.to(() => SettingPage());
                    },
                    icon: const Icon(Icons.settings, size: 30)),
              ),
            ],
          ),
          body: SizedBox(
            height: hei - 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomRefreshIndicator(
                    onRefresh: () async {
                      context.read<BasePostBloc>().add(RequestInitDataEvent());
                      Future.delayed(const Duration(milliseconds: 1500));
                    },
                    builder: (context, child, controller) {
                      return Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          if (controller.value > 0)
                            Positioned(
                                top: controller.value * 30,
                                child: Opacity(
                                  opacity: controller.value.clamp(0, 1),
                                  child: Transform.scale(
                                    scale: controller.value.clamp(0.0, 1.0),
                                    child: Text(
                                      'Grow up with TESTUS',
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                )),
                          Transform.translate(
                            offset: Offset(0, 80 * controller.value),
                            child: child,
                          ),
                        ],
                      );
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
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
                ),
              ],
            ),
          )),
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
                    child: Text(
                      "사이드\n프로젝트",
                      textAlign: TextAlign.center,
                    ),
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
    return Selector<BasePostProvider, List<dynamic>>(selector: (context, provider) {
      List<dynamic> posts = [];
      if (provider.favoritePost != null) {
        if (provider.favoritePost!.isEmpty) {
          return posts;
        }
        for (var post in provider.favoritePost!) {
          if (post is RecruitPostEntity) {
            if (post.status == PostStatus.active) {
              posts.add(post);
            }
          } else {
            if (post.status == PostStatus.active) {
              posts.add(post);
            }
          }
        }
      }
      return posts;
    }, builder: (context, favoritePost, child) {
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
              height: 250,
              width: MediaQuery.sizeOf(context).width,
              // padding: EdgeInsets.all(10),
              // decoration: BoxDecoration(
              //     border: Border.all()
              // ),
              child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, idx) {
                    final isRecruit = favoritePost[idx] is RecruitPostEntity;

                    final bgColor = isRecruit ? const Color(0xFFFFE0B2) : const Color(0xFFE3F2FD);

                    final textColor = isRecruit ? const Color(0xFFBF360C) : const Color(0xFF0D47A1);
                    return GestureDetector(
                      onTap: () async {
                        favoritePost[idx].postType == "RecruitmentPostEntity"
                            ? Get.to(() => RecruitPostDetailPage(postId: favoritePost[idx].id!))
                            : Get.to(() => PromotionPostDetailPage(postId: favoritePost[idx].id!));
                      },
                      child: SizedBox(
                        // height: 220,
                        // width: 200,
                        // decoration: BoxDecoration(
                        //   color: Theme.of(context).colorScheme.surface,
                        // ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 240, maxWidth: 200),
                              child: LayoutBuilder(builder: (context, constraints) {
                                return Stack(
                                  children: [
                                    Container(
                                      width: constraints.maxWidth,
                                      height: constraints.maxHeight * 0.55,
                                      decoration: BoxDecoration(
                                        // color: Colors.green,
                                        border: favoritePost[idx].images!.isEmpty ? Border.all() : null,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: favoritePost[idx].images![0].url ?? '',
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder: (context, url, downloadProgress) {
                                            return Shimmer.fromColors(
                                              baseColor: Colors.grey.shade300,
                                              highlightColor: Colors.grey.shade100,
                                              child: Container(
                                                color: Colors.white,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      // top: 5,
                                      bottom: 5,
                                      right: 5,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: bgColor,
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          isRecruit ? "모집" : "홍보",
                                          style: TextStyle(fontSize: 14, color: textColor),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }),
                            ),
                            const Gap(10),
                            SizedBox(
                                child: Text(
                              "${favoritePost[idx].title}",
                              style:
                                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                              maxLines: 2,
                            )),
                            Row(
                              children: [
                                SizedBox(
                                  child: Text(
                                    favoritePost[idx].platform! == ApplicationPlatform.web ? "WEB" : "Mobile",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey.shade600,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                                if (favoritePost[idx].platform! == ApplicationPlatform.mobile)
                                  SizedBox(
                                    child: Text(
                                      "( ${TypeConversionUtil().getPostOs(favoritePost[idx].mobileOs!)} )",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey.shade600,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(
                                child: Text(
                              TypeConversionUtil().postCategoryToString(favoritePost[idx].category),
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                            )),
                            SizedBox(
                                child: Text(
                              "${favoritePost[idx].author!.nickname}",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
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
        ]);
      }
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
                    child: Text(
                      "전체 보기",
                    ))
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
                  height: 240,
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
                            final isActive = posts[idx].author!.status == UserStatus.active;
                            return GestureDetector(
                              onTap: () async {
                                Get.to(() => RecruitPostDetailPage(postId: posts[idx].id!));
                              },
                              child: SizedBox(
                                height: 240,
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
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                                imageUrl: posts[idx].images![0].url ?? '',
                                                fit: BoxFit.cover,
                                                progressIndicatorBuilder: (context, url, downloadProgress) {
                                                  return Shimmer.fromColors(
                                                    baseColor: Colors.grey.shade300,
                                                    highlightColor: Colors.grey.shade100,
                                                    child: Container(
                                                      color: Colors.white,
                                                    ),
                                                  );
                                                }),
                                          ),
                                        );
                                      }),
                                    ),
                                    SizedBox(
                                        child: Text(
                                      "${posts[idx].title}",
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                                      maxLines: 2,
                                    )),
                                    Row(
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            posts[idx].platform!.name.toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.grey.shade600,
                                                overflow: TextOverflow.ellipsis),
                                          ),
                                        ),
                                        if (posts[idx].platform == ApplicationPlatform.mobile)
                                          SizedBox(
                                            child: Text(
                                              "( ${TypeConversionUtil().getPostOs(posts[idx].mobileOs!)} )",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey.shade600,
                                                  overflow: TextOverflow.ellipsis),
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(
                                      child: Text(
                                        TypeConversionUtil().postCategoryToString(posts[idx].category!),
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
                                      isActive ? posts[idx].author!.nickname ?? '알수 없는 회원' : '알수 없는 회원',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
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
                  height: 240,
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
                            final isActive = posts[idx].author!.status == UserStatus.active;
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
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl: posts[idx].images![0].url ?? '',
                                              fit: BoxFit.cover,
                                              progressIndicatorBuilder: (context, url, pro) {
                                                return Shimmer.fromColors(
                                                    baseColor: Colors.grey.shade300,
                                                    highlightColor: Colors.grey.shade100,
                                                    child: Container(
                                                      color: Colors.white,
                                                    ));
                                              },
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                    const Gap(5),
                                    SizedBox(
                                        child: Text(
                                      "${posts[idx].title}",
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                                      maxLines: 2,
                                    )),
                                    Row(
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            posts[idx].platform!.name.toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.grey.shade600,
                                                overflow: TextOverflow.ellipsis),
                                          ),
                                        ),
                                        if (posts[idx].platform == ApplicationPlatform.mobile)
                                          SizedBox(
                                            child: Text(
                                              "( ${TypeConversionUtil().getPostOs(posts[idx].mobileOs!)} )",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey.shade600,
                                                  overflow: TextOverflow.ellipsis),
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(
                                      child: Text(
                                        TypeConversionUtil().postCategoryToString(posts[idx].category!),
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
                                      isActive ? posts[idx].author!.nickname ?? '알수 없는 회원' : '알수 없는 회원',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
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
