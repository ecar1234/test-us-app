import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/domain/entities/recruit_post_entity.dart';
import 'package:test_us_app/presentation/provider/post_provider/base_post_provider.dart';
import 'package:test_us_app/presentation/provider/post_provider/recruit_post_provider.dart';
import 'package:test_us_app/utils/time_util.dart';
import 'package:test_us_app/utils/type_conversion_util.dart';
import '../../../../data/models/application/application_model.dart';
import '../../../../data/models/post/recruit_post_model.dart';
import '../../../../services/common_height_provider.dart';
import '../../../../services/theme_provider.dart';
import '../../../bloc/post_blocs/recruit_post_bloc/recruit_post_bloc.dart';
import '../../../bloc/post_blocs/recruit_post_bloc/recruit_post_event.dart';
import '../../../bloc/post_blocs/recruit_post_bloc/recruit_post_state.dart';
import '../../../provider/user_provider.dart';
import '../../post/tester_post_pages/recruit_post_detail_page.dart';
import 'application_management_page.dart';

class MyRecruitmentPage extends StatefulWidget {
  const MyRecruitmentPage({super.key});

  @override
  State<MyRecruitmentPage> createState() => _MyRecruitmentPageState();
}

class _MyRecruitmentPageState extends State<MyRecruitmentPage> {
  late RecruitPostBloc recruitPostBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    recruitPostBloc = context.read<RecruitPostBloc>();
    final token = context.read<UserProvider>().token ?? '';
    final userId = context.read<UserProvider>().user!.id!;
    recruitPostBloc.add(RequestUserRecruitmentPosts(token, userId));
  }

  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei!;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("테스터 모집 관리"),
      ),
      body: BlocListener<RecruitPostBloc, RecruitPostState>(
        listener: (context, state) {
          if (state.state == RecruitPostLoadState.postEndCompletedState) {
            context.read<BasePostProvider>().updateRecruitPost(state.post!);
            context.read<BasePostProvider>().updateUserRecruitPosts(state.post!);
          }
          else if(state.state == RecruitPostLoadState.getUserRecruitmentPostsCompletedState){
            context.read<RecruitPostProvider>().getUserRecruitmentPosts(state.posts!);
          }
        },
        child: Selector<BasePostProvider, List<RecruitPostEntity>>(selector: (context, provider) {
          List<RecruitPostEntity> posts = [];
          if (provider.userRecruitPosts != null) {
            if (provider.userRecruitPosts!.isEmpty) {
              return posts;
            }
            for (int i = 0; i < provider.userRecruitPosts!.length; i++) {
              if (provider.userRecruitPosts![i].status != PostStatus.end &&
                  provider.userRecruitPosts![i].status != PostStatus.delete) {
                posts.add(provider.userRecruitPosts![i]);
              }
            }
          }
          return posts;
        }, builder: (context, posts, child) {
          if (posts.isEmpty) {
            return SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: hei,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('작성 된 모집글이 없습니다.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  const Gap(10),
                  Text('나만의 서비스가 있다면 테스터를'),
                  Text('모집해 보세요.'),
                ],
              ),
            );
          }
          return _postsInfoBuilder(posts, hei);
        }),
      ),
    ));
  }

  Widget _postsInfoBuilder(List<RecruitPostEntity> posts, double hei) {
    final isDarkMode = context.read<ThemeProvider>().isDarkMode;
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 20),
              itemBuilder: (context, idx) {
                bool isExpired = posts[idx].status == PostStatus.expired;
                return GestureDetector(
                  onTap: isExpired
                      ? null
                      : () {
                          Get.to(() => RecruitPostDetailPage(postId: posts[idx].id!));
                        },
                  child: Container(
                    height: 155,
                    width: MediaQuery.sizeOf(context).width,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: isDarkMode
                            ? null
                            : [
                                BoxShadow(
                                  color: Colors.grey.withAlpha(84),
                                  spreadRadius: 2,
                                  blurRadius: 9,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                            flex: 3,
                            child: SizedBox(
                                width: (MediaQuery.sizeOf(context).width - 50) * 0.35,
                                // height: 140,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: posts[idx].images![0].url!,
                                    fit: BoxFit.cover,
                                    color: isExpired ? Colors.grey.shade200 : null,
                                    colorBlendMode: isExpired ? BlendMode.saturation : null,
                                  ),
                                ))),
                        Flexible(
                          flex: 7,
                          child: Container(
                            // height: 140,
                            width: (MediaQuery.sizeOf(context).width - 50) * 0.65,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: 30,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          posts[idx].title!,
                                          style: TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(child: Text(posts[idx].platform!.name.toUpperCase())),
                                        if (posts[idx].platform == ApplicationPlatform.mobile)
                                          Text(' (${TypeConversionUtil().getPostOs(posts[idx].mobileOs!)})')
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // NOTE: 현재는 period가 7일로 고정 되어 있지만, 상확에 따라 변경필요, 변수로 period 포함 시키는 로직 필요.
                                      Text('게시 만료 : ${TimeUtil().getDateTimeString(posts[idx].createdAt!
                                          .add(Duration(days: 7)), false)}'),
                                    ],
                                  )),
                                ],
                              ),
                              // const Gap(10),
                              if (isExpired)
                                SizedBox(
                                  height: 40,
                                  width: (MediaQuery.sizeOf(context).width - 50) * 0.65,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        //TODO: 테스트 종료 -> status.end 로 update
                                        //TODO: alert으로 테스트 종료 시 리뷰를 쓰도록 이동 또는 알림
                                        final token = context.read<UserProvider>().token ?? '';
                                        final postId = posts[idx].id!;
                                        context.read<RecruitPostBloc>().add(RequestPostEndEvent(token, postId));
                                      },
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          )),
                                      child: Text('테스트 종료')),
                                )
                              else
                                SizedBox(
                                  height: 40,
                                  width: (MediaQuery.sizeOf(context).width - 50) * 0.65,
                                  child: ElevatedButton(
                                    onPressed: posts[idx].applications!.isEmpty
                                        ? null
                                        : () {
                                            Get.to(() => ApplicationManagementPage(postId: posts[idx].id!));
                                          },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('신청 인원', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                        Text(
                                            ' ( ${posts[idx].applications!.isEmpty ? 0 : posts[idx].applications!.length} / 8 )'),
                                      ],
                                    ),
                                  ),
                                ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, idx) => const Gap(20),
              itemCount: posts.length)),
    );
  }

// int _getApplicantLength(RecruitPostEntity post) {
//   int length = 0;
//   if (post.applications != null && post.applications!.isNotEmpty) {
//     for (final application in post.applications!) {
//       if (application.status != ApplicationStatus.cancel || application.status == null) {
//         length++;
//       }
//     }
//   }
//   return length;
// }
}
