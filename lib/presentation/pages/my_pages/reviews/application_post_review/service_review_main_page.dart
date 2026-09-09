import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/domain/entities/post_review_entity.dart';
import 'package:test_us_app/presentation/bloc/review_bloc/review_bloc.dart';
import 'package:test_us_app/presentation/bloc/review_bloc/review_event.dart';
import 'package:test_us_app/presentation/provider/review_provider.dart';
import 'package:test_us_app/services/theme_provider.dart';

import '../../../../../data/models/application/application_model.dart';
import '../../../../../data/models/post/recruit_post_model.dart';
import '../../../../../domain/entities/recruit_post_entity.dart';
import '../../../../../services/common_height_provider.dart';
import '../../../../../utils/time_util.dart';
import '../../../../../utils/type_conversion_util.dart';
import '../../../../bloc/review_bloc/review_state.dart';
import '../../../../provider/application_provider.dart';
import '../../../../provider/user_provider.dart';
import 'add_service_review_page.dart';

class ServiceReviewMainPage extends StatefulWidget {
  const ServiceReviewMainPage({super.key});

  @override
  State<ServiceReviewMainPage> createState() => _ServiceReviewMainPageState();
}

class _ServiceReviewMainPageState extends State<ServiceReviewMainPage> {

  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final token = context.read<UserProvider>().token!;

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.read<ThemeProvider>().isDarkMode;
    return Selector<ApplicationProvider, List<RecruitPostEntity>>(
      selector: (context, provider) {
        List<RecruitPostEntity> posts = [];
        if (provider.userApplicationPosts != null) {
          if (provider.userApplicationPosts!.isEmpty) {
            return posts;
          }

          for (var post in provider.userApplicationPosts!) {
            if (post.status == PostStatus.end) {
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
              return Stack(
                children: [
                  Container(
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
                        const Gap(10),
                        Flexible(
                          flex: 7,
                          child: Container(
                            width: (MediaQuery.sizeOf(context).width - 50) * 0.65,
                            padding: EdgeInsets.only(bottom: 5),
                            child: Column(mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              SizedBox(
                                // height: 30,
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
                              const Gap(5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(posts[idx].platform!.name.toUpperCase(), style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),),
                                  if (posts[idx].platform == ApplicationPlatform.mobile)
                                    Text(
                                      "( ${TypeConversionUtil().getPostOs(posts[idx].mobileOs!)} )",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    )
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
                              SizedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // NOTE: 현재는 period가 7일로 고정 되어 있지만, 상확에 따라 변경필요, 변수로 period 포함 시키는 로직 필요.
                                      Text('테스트 종료일 : ${TimeUtil().getDateTimeString(posts[idx].updatedAt!, false)}'),
                                    ],
                                  )),
                              const Gap(10),
                              //Fixme: post의 review를 삭제하고 다시 가져오는 방법을 찾아야함.
                                  SizedBox(
                                    height: 30,
                                    width: (MediaQuery
                                        .sizeOf(context)
                                        .width - 50) * 0.65,
                                    child: Selector<ReviewProvider, PostReviewEntity?>(
                                      selector: (context, provider) {
                                        final reviews = provider.applicationPostReviews!;
                                        if(reviews.isEmpty){
                                          return null;
                                        }else if(reviews.any((review) => review.postId == posts[idx].id)){
                                          return reviews.firstWhere((review) => review.postId == posts[idx].id);
                                        }else {
                                          return null;
                                        }
                                        
                                      },
                                      builder: (context, review, child) {
                                        return ElevatedButton(
                                            onPressed: () async {
                                              if(review != null){
                                                await _checkReviewedModal(
                                                    context, posts[idx].title!, review);
                                              }else {
                                                Get.to(() => AddServiceReviewPage(post: posts[idx]));
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    10),
                                              ),
                                              elevation: 2,
                                            ),
                                            child: Text(review != null ? '리뷰확인 하기' : '리뷰 작성 하기'));
                                      },
                                    ),
                                  )
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Fixme: post의 review를 삭제하고 다시 가져오는 방법을 찾아야함.
                  // if(posts[idx].reviews!.any((element) => element.reviewerUserId == context.read<UserProvider>().user!.id!))
                  //   Positioned(
                  //     top: 10,
                  //     right: 20,
                  //     child: SizedBox(
                  //       height: 50,
                  //       width: 50,
                  //       child: Icon(
                  //         Symbols.task_alt,
                  //         color: Colors.green,
                  //         size: 40,
                  //       ),
                  //     ),
                  //   )
                ],
              );
            },
            separatorBuilder: (context, idx) => const Gap(20),
          ),
        );
      },
    );
  }

  Future<void> _checkReviewedModal(BuildContext context, String title, PostReviewEntity review) async {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei!;
    _contentController.text = review.comment!;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
                height: hei * 0.7,
                width: MediaQuery.sizeOf(context).width - 40,
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(20),
                    RatingBar.builder(
                      initialRating: review.rating!,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                      ignoreGestures: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Icon(
                          Icons.star,
                          color: Colors.amber,
                        );
                      },
                      onRatingUpdate: (double value) {},
                    ),
                    Text('평점: ${review.rating}', style: TextStyle(fontSize: 16)),
                    const Gap(20),
                    SizedBox(
                      height: hei * 0.3,
                      child: TextField(
                        controller: _contentController,
                        readOnly: true,
                        minLines: 20,
                        maxLines: 30,
                      ),
                    ),
                    const Gap(20),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(
                          height: 50,
                          width: 100,
                          child: ElevatedButton(
                              onPressed: () {
                                _contentController.clear();
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                              child: Text('확인')))
                    ])
                  ],
                )),
          );
        });
  }
}
