import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/presentation/bloc/review_bloc/review_bloc.dart';
import 'package:test_us_app/presentation/bloc/review_bloc/review_event.dart';
import 'package:test_us_app/services/theme_provider.dart';

import '../../../../../data/models/post/recruit_post_model.dart';
import '../../../../../domain/entities/recruit_post_entity.dart';
import '../../../../../services/common_height_provider.dart';
import '../../../../../utils/time_util.dart';
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
                              if (posts[idx]
                                  .reviews!
                                  .any((element) => element.reviewerUserId == context.read<UserProvider>().user!.id!))
                                SizedBox(
                                  height: 30,
                                  width: (MediaQuery.sizeOf(context).width - 50) * 0.65,
                                  child: ElevatedButton(
                                      onPressed: ()async {
                                        await _checkReviewedModal(context, posts[idx]);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        elevation: 2,
                                      ),
                                      child: Text('나의 리뷰 보기')),
                                )
                              else
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
                  ),
                  if(posts[idx].reviews!.any((element) => element.reviewerUserId == context.read<UserProvider>().user!.id!))
                    Positioned(
                      top: 10,
                      right: 20,
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: Icon(
                          Symbols.task_alt,
                          color: Colors.green,
                          size: 40,
                        ),
                      ),
                    )
                ],
              );
            },
            separatorBuilder: (context, idx) => const Gap(20),
          ),
        );
      },
    );
  }

  Future<void> _checkReviewedModal(BuildContext context, RecruitPostEntity post) async {
    final token = context.read<UserProvider>().token!;
    final reviewId = post.reviews!.firstWhere((element) => element.reviewerUserId == context.read<UserProvider>().user!.id!).reviewId ?? "";
    if(reviewId.isEmpty) {
      return showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('알림'),
      content: Text('리뷰가 존재 하지 않습니다.'),
      actions: [
        TextButton(onPressed: () {
          Navigator.pop(context);
        }, child: Text('확인'))
      ]
    ));
    }
    // final review = context.read<ReviewBloc>().add(RequestReviewByPostReviewIdEvent()
    context.read<ReviewBloc>().add(RequestReviewByPostReviewIdEvent(token, reviewId));
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei!;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return BlocConsumer<ReviewBloc, ReviewState>(
            listener: (context, state){},
            builder:(context, state) {
              if(state is GetReviewByPostReviewIdCompletedState) {
                return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                insetPadding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                    height: hei * 0.6,
                    width: MediaQuery.sizeOf(context).width - 40,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          '${post.title}',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Gap(20),
                        RatingBar.builder(
                          initialRating: state.review.rating!,
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
                        Text('평점: ${state.review.rating}', style: TextStyle(fontSize: 16)),
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
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                  child: Text('확인')))
                        ])
                      ],
                    )),
              );
              }else if(state.state == ReviewDataState.errorState) {
                return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    insetPadding: EdgeInsets.symmetric(horizontal: 20),
                    child: Container( height: hei * 0.3,
                      width: MediaQuery.sizeOf(context).width - 40,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            '리뷰를 불러오는중 오류가 발생했습니다.',),
                          const Gap(20),
                          CircularProgressIndicator(),
                          const Gap(20),
                          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            SizedBox(
                                height: 50,
                                width: 100,
                              child: ElevatedButton(onPressed: (){}, child: Text('닫기')),
                            )
                          ])
                        ],
                      )
                    )
                );
              }else {
                return Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  insetPadding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: hei * 0.6,
                    width: MediaQuery.sizeOf(context).width - 40,
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: CircularProgressIndicator(),
                    )
                  )
                );
              }
            },
          );
        });
  }
}
