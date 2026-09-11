import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/presentation/pages/my_pages/reviews/user_review_page/check_post_review_page.dart';
import 'package:test_us_app/presentation/provider/post_provider/base_post_provider.dart';

import '../../../../../data/models/post/recruit_post_model.dart';
import '../../../../../domain/entities/recruit_post_entity.dart';
import '../../../../../services/theme_provider.dart';
import '../../../../../utils/time_util.dart';

class RecruitPostReviewPage extends StatefulWidget {
  const RecruitPostReviewPage({super.key});

  @override
  State<RecruitPostReviewPage> createState() => _RecruitPostReviewPageState();
}

class _RecruitPostReviewPageState extends State<RecruitPostReviewPage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    return LayoutBuilder(
      builder: (context, constrains) =>
          Container(
          height: constrains.maxHeight,
          width: MediaQuery.sizeOf(context).width,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Selector<BasePostProvider, List<RecruitPostEntity>>(
              selector: (context, provider) {
            return provider.userRecruitPosts ?? [];
          }, builder: (context, posts, child) {
            if (posts.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('테스터 모집 게시글이 없네요.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Gap(10),
                  Text('지금 첫 모집글을 작성해서,'),
                  Text(' 더 많은 사용자에게 프로덕트를 알려보세요.')],
              );
            }
            return ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 20),
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
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
                                height: 140,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: posts[idx].images![0].url!,
                                    fit: BoxFit.cover,
                                  ),
                                ))),
                        const Gap(10),
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
                                      child: Text('플랫폼 : ${posts[idx].platform!.name.toUpperCase()}')
                                  ),
                                ],
                              ),
                              SizedBox(
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                    Text('신청 : '),
                                    const Gap(10),
                                    Text(
                                        '${posts[idx].applications!.length} 명',
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
                              SizedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    //Fixme: post의 review를 삭제하고 다시 가져오는 방법을 찾아야함.
                                    // Text('평점 : ${_getAverageRating(posts[idx].reviews!)}',
                                    //     style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  ]
                                )
                              ),
                              const Gap(5),
                              //Fixme: post의 review를 삭제하고 다시 가져오는 방법을 찾아야함.
                              // if (posts[idx].status == PostStatus.end && posts[idx].reviews!.isNotEmpty)
                              //   SizedBox(
                              //     height: 30,
                              //     width: (MediaQuery.sizeOf(context).width - 50) * 0.65,
                              //     child: ElevatedButton(
                              //         onPressed: () {
                              //           // Get.to(() => CheckPostReviewPage(reviews: posts[idx].reviews!));
                              //         },
                              //         style: ElevatedButton.styleFrom(
                              //           padding: EdgeInsets.zero,
                              //           shape: RoundedRectangleBorder(
                              //             borderRadius: BorderRadius.circular(10),
                              //           ),
                              //           elevation: 2,
                              //         ),
                              //         child: Text('리뷰 확인하기')),
                              //   )
                              // else if (posts[idx].status == PostStatus.active)
                              //   SizedBox(
                              //     height: 30,
                              //     width: (MediaQuery.sizeOf(context).width - 50) * 0.65,
                              //     child: ElevatedButton(
                              //         onPressed: null,
                              //         style: ElevatedButton.styleFrom(
                              //           padding: EdgeInsets.zero,
                              //           shape: RoundedRectangleBorder(
                              //             borderRadius: BorderRadius.circular(10),
                              //           ),
                              //           elevation: 2,
                              //         ),
                              //         child: Text('아직 모집 or 테스트 중 입니다')),
                              //   )
                              // else if (posts[idx].status == PostStatus.expired)
                              //   SizedBox(
                              //     height: 30,
                              //     width: (MediaQuery.sizeOf(context).width - 50) * 0.65,
                              //     child: ElevatedButton(
                              //         onPressed: null,
                              //         style: ElevatedButton.styleFrom(
                              //           padding: EdgeInsets.zero,
                              //           shape: RoundedRectangleBorder(
                              //             borderRadius: BorderRadius.circular(10),
                              //           ),
                              //           elevation: 2,
                              //         ),
                              //         child: Text('먼저 테스트를 종료해 주세요.')),
                              //   )
                              // else
                              //   SizedBox(
                              //     height: 30,
                              //     width: (MediaQuery.sizeOf(context).width - 50) * 0.65,
                              //     child: ElevatedButton(
                              //         onPressed: null,
                              //         style: ElevatedButton.styleFrom(
                              //           padding: EdgeInsets.zero,
                              //           shape: RoundedRectangleBorder(
                              //             borderRadius: BorderRadius.circular(10),
                              //           ),
                              //           elevation: 2,
                              //         ),
                              //         child: Text('확인 할 리뷰가 없습니다.')),
                              //   )
                            ]),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, idx) => const Gap(20),
                itemCount: posts.length);
          })),
    );
  }
  double _getAverageRating(List<RecruitReviewEntity> reviews) {
    if (reviews.isEmpty) {
      return 0.0;
    }
    double totalRating = 0.0;
    for (var review in reviews) {
      totalRating += review.rating!;
    }
    return totalRating / reviews.length;
  }
}
