import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/data/models/application/application_model.dart';
import 'package:test_us_app/presentation/pages/my_pages/reviews/tester_review_page.dart';

import '../../../../data/models/post/recruit_post_model.dart';
import '../../../../domain/entities/application_entity.dart';
import '../../../../domain/entities/recruit_post_entity.dart';
import '../../../../services/common_height_provider.dart';
import '../../../../services/theme_provider.dart';
import '../../../../utils/time_util.dart';
import '../../../provider/application_provider.dart';
import '../../../provider/post_provider/base_post_provider.dart';
import 'add_service_review_page.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final List<bool> _selected = [true, false, false];

  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei!;
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("리뷰 관리"),
        ),
        body: SizedBox(
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
                            ? _testerReviewPage(isDarkMode)
                            : (_selected[1] ? _serviceReviewPage(isDarkMode) : _myReviewPage(isDarkMode))))
              ],
            )),
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

  Widget _testerReviewPage(bool isDarkMode) {
    return Selector<BasePostProvider, List<RecruitPostEntity>>(
      selector: (context, provider) {
        List<RecruitPostEntity> posts = [];
        if (provider.userRecruitPosts != null) {
          for (int i = 0; i < provider.userRecruitPosts!.length; i++) {
            if (provider.userRecruitPosts![i].status == PostStatus.end) {
              posts.add(provider.userRecruitPosts![i]);
            }
          }
        }
        return posts;
      },
      builder: (context, posts, child) => Container(
        key: ValueKey(0),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: posts.isEmpty
            ? Text(
                "리뷰를 진행 할 프로젝트가 없습니다.",
                style: TextStyle(fontSize: 16),
              )
            : ListView.separated(
                itemCount: posts.length,
                itemBuilder: (context, idx) {
                  return Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                        border: isDarkMode ? null : Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(10),
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
                      children: [
                        Flexible(
                            flex: 3,
                            child: SizedBox(
                                // width: (MediaQuery.sizeOf(context).width - 50) * 0.35,
                                height: 130,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: posts[idx].images![0].url!,
                                    fit: BoxFit.cover,
                                  ),
                                ))),
                        const Gap(5),
                        Flexible(
                          flex: 7,
                          child: SizedBox(
                            // width: (MediaQuery.sizeOf(context).width - 50) * 0.65,
                            // padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    child: posts[idx].platform!.length == 1
                                        ? Text('플랫폼 : ${posts[idx].platform![0]}')
                                        : Text('플랫폼 : ${posts[idx].platform![0]} / ${posts[idx].platform![1]}'),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                    Text('테스터 수 : '),
                                    const Gap(10),
                                    Text(
                                        '${posts[idx].applications!.map((item) => item.status == ApplicationStatus.accepted).length} 명',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                                  ])),
                              SizedBox(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // NOTE: 현재는 period가 7일로 고정 되어 있지만, 상확에 따라 변경필요, 변수로 period 포함 시키는 로직 필요.
                                  Text('테스트 종료일 : ${TimeUtil().getDateTimeString(posts[idx].updatedAt!, false)}'),
                                ],
                              )),
                              const Gap(5),
                              SizedBox(
                                height: 30,
                                width: (MediaQuery.sizeOf(context).width - 50) * 0.65,
                                child: ElevatedButton(
                                    onPressed: posts[idx]
                                            .applications!
                                            .map((item) => item.status == ApplicationStatus.accepted)
                                            .isEmpty
                                        ? null
                                        : () {
                                            Get.to(() => TesterReviewPage(applications: posts[idx].applications!, postId: posts[idx].id!,));
                                          },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: Text('테스터 리뷰 하기')),
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, idx) => const Gap(20),
              ),
      ),
    );
  }

  Widget _serviceReviewPage(bool isDarkMode) {
    return Selector<ApplicationProvider, List<RecruitPostEntity>>(
      selector: (context, provider) {
        List<RecruitPostEntity> posts = [];
        if(provider.userApplicationPosts != null){
          if(provider.userApplicationPosts!.isEmpty) {
            return posts;
          }

          for(var post in provider.userApplicationPosts!){
            if(post.status == PostStatus.end){
              posts.add(post);
            }
          }
        }
        return posts;
      },
      builder: (context, posts, child) {
        return Container(
          key: ValueKey(1),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: posts.isEmpty
              ? Text(
                  "리뷰를 진행 할 프로젝트가 없습니다.",
                  style: TextStyle(fontSize: 16),
                )
              : ListView.separated(
                  itemCount: posts.length,
                  itemBuilder: (context, idx) {
                    return Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                          border: isDarkMode ? null : Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(10),
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
                        children: [
                          Flexible(
                              flex: 3,
                              child: SizedBox(
                                  // width: (MediaQuery.sizeOf(context).width - 50) * 0.35,
                                  height: 130,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: posts[idx].images![0].url!,
                                      fit: BoxFit.cover,
                                    ),
                                  ))),
                          const Gap(5),
                          Flexible(
                            flex: 7,
                            child: SizedBox(
                              // width: (MediaQuery.sizeOf(context).width - 50) * 0.65,
                              // padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                                const Gap(10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      child: posts[idx].platform!.length == 1
                                          ? Text('플랫폼 : ${posts[idx].platform![0]}')
                                          : Text('플랫폼 : ${posts[idx].platform![0]} / ${posts[idx].platform![1]}'),
                                    ),
                                  ],
                                ),
                                const Gap(5),
                                SizedBox(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // NOTE: 현재는 period가 7일로 고정 되어 있지만, 상확에 따라 변경필요, 변수로 period 포함 시키는 로직 필요.
                                    Text('테스트 종료일 : ${TimeUtil().getDateTimeString(posts[idx].updatedAt!, false)}'),
                                  ],
                                )),
                                const Gap(10),
                                SizedBox(
                                  height: 30,
                                  width: (MediaQuery.sizeOf(context).width - 50) * 0.65,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Get.to(() => AddServiceReviewPage(post: posts[idx]));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        elevation: 2,
                                      ),
                                      child: Text('서비스 리뷰 하기')),
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, idx) => const Gap(20),
                ),
        );
      },
    );
  }

  Widget _myReviewPage(bool isDarkMode) {
    return Container(
      key: ValueKey(2),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text("나의 리뷰"),
    );
  }
}
