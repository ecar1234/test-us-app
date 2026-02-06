import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/presentation/pages/my_pages/reviews/tester_review/tester_review_page.dart';

import '../../../../../data/models/application/application_model.dart';
import '../../../../../data/models/post/recruit_post_model.dart';
import '../../../../../domain/entities/recruit_post_entity.dart';
import '../../../../../services/theme_provider.dart';
import '../../../../../utils/time_util.dart';
import '../../../../../utils/type_conversion_util.dart';
import '../../../../provider/post_provider/base_post_provider.dart';

class TesterReviewMainPage extends StatefulWidget {
  const TesterReviewMainPage({super.key});

  @override
  State<TesterReviewMainPage> createState() => _TesterReviewMainPageState();
}

class _TesterReviewMainPageState extends State<TesterReviewMainPage> {
  @override
  void initState() {
    super.initState();
    // TODO: application 정보가 담긴 새로운 posts 를 받아오거나...
    // TODO: post를 받아 올때, pending, accept만 받아와서 applications.length > 0 페이지 이동.
    // TODo: 신청인원은 accept 상관 없이 보여주고, 상세페이지에서 State에 따라서 다른게 표시.
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    return Selector<BasePostProvider, List<RecruitPostEntity>>(
      selector: (context, provider) {
        List<RecruitPostEntity> posts = [];
        if (provider.userRecruitPosts != null) {
          for (int i = 0; i < provider.userRecruitPosts!.length; i++) {
            if (provider.userRecruitPosts![i].status == PostStatus.end &&
                provider.userRecruitPosts![i].applications!.isNotEmpty) {
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
                                width: double.infinity,
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
                                  Text(posts[idx].platform!.name.toUpperCase()),
                                  if (posts[idx].platform == ApplicationPlatform.mobile)
                                    Text(
                                      "( ${TypeConversionUtil().getPostOs(posts[idx].mobileOs!)} )",
                                    )
                                ],
                              ),
                              SizedBox(
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                    Text('참여 유져 : '),
                                    const Gap(10),
                                    Text('${posts[idx].applications!.length} 명',
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
                                    onPressed: posts[idx].applications!.isEmpty
                                        ? null
                                        : () {
                                            Get.to(() => TesterReviewPage(
                                                  applications: posts[idx].applications!,
                                                  postId: posts[idx].id!,
                                                ));
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
}
