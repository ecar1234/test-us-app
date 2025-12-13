import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/data/models/post/recruit_post_model.dart';
import 'package:test_us_app/domain/entities/recruit_post_entity.dart';
import 'package:test_us_app/domain/entities/user_review_entity.dart';
import 'package:test_us_app/presentation/provider/review_provider.dart';

import '../../../../../data/models/application/application_model.dart';
import '../../../../../services/theme_provider.dart';
import '../../../../../utils/time_util.dart';
import '../../../../provider/application_provider.dart';

class UserTesterReviewPage extends StatefulWidget {
  const UserTesterReviewPage({super.key});

  @override
  State<UserTesterReviewPage> createState() => _UserTesterReviewPageState();
}

class _UserTesterReviewPageState extends State<UserTesterReviewPage> {

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.read<ThemeProvider>().isDarkMode;
    return LayoutBuilder(builder: (context, constrains) {
      return Selector<ApplicationProvider, List<RecruitPostEntity>>(
        selector: (context, provider) {
          final posts = provider.userApplicationPosts!.where((e) => e.status != PostStatus.delete).toList();
          if (posts.isEmpty) {
            return [];
          }
          return posts;
        },
        builder: (context, posts, child) {
          if (posts.isEmpty) {
            return Container(
                key: ValueKey('userReviewEmpty'),
                height: constrains.maxHeight,
                width: MediaQuery.sizeOf(context).width,
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('전달받은 리뷰가 없습니다.'),
                  ],
                ));
          }
          final userReviews = context.read<ReviewProvider>().userReviews ?? [];
          return Container(
              key: ValueKey('userReviews'),
              height: constrains.maxHeight,
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                    child: Column(
                      children: [
                        Text("나의 평점", style: TextStyle(fontSize: 20,)),
                        Text("${_getAverageRating(userReviews).toStringAsFixed(1)} 점", style: TextStyle(fontSize: 30,
                            color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold))
                      ]
                    ),
                  ),
                  // Divider(color: Colors.grey.shade200,),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 10),
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, idx) {
                          final reviewFromPost = userReviews.firstWhere((e) {
                            for (var app in posts[idx].applications!) {
                              for (var review in userReviews) {
                                if (review.applicationId == app.id) {
                                  return true;
                                } else {
                                  return false;
                                }
                              }
                            }
                            return false;
                          }, orElse: () => UserReviewEntity());
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
                              child: Column(
                                children: [
                                  // post info
                                  Row(
                                    children: [
                                      Flexible(
                                          flex: 3,
                                          child: SizedBox(
                                            // width: (MediaQuery.sizeOf(context).width - 50) * 0.35,
                                              height: 100,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: CachedNetworkImage(
                                                  imageUrl: posts[idx].images![0].url!,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
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
                                            // const Gap(5),
                                            // SizedBox(
                                            //   height: 30,
                                            //   width: (MediaQuery.sizeOf(context).width - 50) * 0.65,
                                            //   child: ElevatedButton(
                                            //       onPressed: (){},
                                            //       style: ElevatedButton.styleFrom(
                                            //         padding: EdgeInsets.zero,
                                            //         shape: RoundedRectangleBorder(
                                            //           borderRadius: BorderRadius.circular(10),
                                            //         ),
                                            //         elevation: 2,
                                            //       ),
                                            //       child: Text('리뷰 확인하기')),
                                            // ),
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(10),
                                  // review
                                  if(reviewFromPost.rating != null)
                                  Column(
                                    children: [
                                      // Rating builder
                                      RatingBar.builder(
                                          initialRating: reviewFromPost.rating!,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                          ignoreGestures: true,
                                          itemBuilder: (context, idx){
                                        return Icon(Icons.star, color: Colors.amber,);
                                      }, onRatingUpdate: (double value){}),
                                      // Rating
                                      Text('평점 : ${reviewFromPost.rating}', style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.primary)),
                                      const Gap(20),
                                      Text(reviewFromPost.comment!)
                                      // comment
                                    ],
                                  )
                                  else
                                  Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                      child: Text('전송된 리뷰가 없습니다.')))
                                ],
                              ));
                        },
                        separatorBuilder: (context, idx) => const Gap(20),
                        itemCount: posts.length),
                  ),
                ],
              ));
        },
      );
    });
  }

  double _getAverageRating(List<UserReviewEntity> reviews) {
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
