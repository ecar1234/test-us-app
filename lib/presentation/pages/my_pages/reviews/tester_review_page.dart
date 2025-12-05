import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/domain/entities/application_entity.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';
import 'package:test_us_app/presentation/bloc/review_bloc/review_bloc.dart';
import 'package:test_us_app/presentation/bloc/review_bloc/review_state.dart';
import 'package:test_us_app/presentation/provider/review_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/services/theme_provider.dart';

import '../../../../data/models/application/application_model.dart';
import '../../../../domain/entities/user_review_entity.dart';
import '../../../../services/common_height_provider.dart';
import '../../../bloc/app_bloc/app_bloc.dart';
import '../../../bloc/review_bloc/review_event.dart';
import 'add_tester_review_page.dart';

class TesterReviewPage extends StatefulWidget {
  final List<ApplicationEntity> applications;
  final String postId;

  const TesterReviewPage({super.key, required this.applications, required this.postId});

  @override
  State<TesterReviewPage> createState() => _TesterReviewPageState();
}

class _TesterReviewPageState extends State<TesterReviewPage> {
  List<UserEntity> _users = [];

  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final testersId = widget.applications.map((e) => e.applicantId!).toList();
    final token = context.read<UserProvider>().token!;
    context.read<ReviewBloc>().add(RequestTestersReviewEvent(token, testersId, widget.applications[0].id!));
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
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("테스터 리뷰"),
            ),
            body: BlocConsumer<ReviewBloc, ReviewState>(listener: (context, state) {
              if (state is GetTestersReviewDataCompletedState) {
                context.read<ReviewProvider>().setTestersReview(state.reviews);
                if (_users.isEmpty) {
                  setState(() {
                    _users = state.users;
                  });
                }
              } else if (state is CreateUserReviewCompletedState) {
                context.read<ReviewProvider>().updateTesterReview(state.review);
                context.read<ReviewBloc>().add(ChangeStateToGetTestersReview(
                    reviews: context.read<ReviewProvider>().testersReviewOnPost!, users: _users));
              }
              if (state.state == ReviewDataState.errorState || state.state == ReviewDataState.failedState) {
                return;
              }
            }, builder: (context, state) {
              if (state is GetTestersReviewDataCompletedState) {
                return ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, idx) {
                      final application =
                          widget.applications.firstWhere((element) => element.applicantId == state.users[idx].id!);
                      // UserReviewEntity? review = _testersReviewData[idx]['review'];
                      return Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Text("테스 ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                    SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: CircleAvatar(
                                            backgroundImage: state.users[idx].profileImg!.url == null
                                                ? const AssetImage('assets/images/Generic avatar.png')
                                                : CachedNetworkImageProvider(state.users[idx].profileImg!.url!))),
                                    const Gap(10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(state.users[idx].nickname!,
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                            const Gap(10),
                                            Text('( ${_getPlatform(application.platform!)} )',
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                        Text(state.users[idx].email!, style: TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                  ],
                                ),
                                const Gap(10),
                                Selector<ReviewProvider, UserReviewEntity?>(selector: (context, provider) {
                                  UserReviewEntity? review;
                                  if (provider.testersReviewOnPost != null) {
                                    if (provider.testersReviewOnPost!.isEmpty) return null;
                                    review = provider.testersReviewOnPost!
                                        .firstWhere((element) => element.reviewedId == state.users[idx].id);
                                  }
                                  return review;
                                }, builder: (context, review, child) {
                                  if (review == null) {
                                    return SizedBox(
                                      height: 40,
                                      width: 200,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Get.to(() => AddTesterReviewPage(
                                                tester: state.users[idx], application: application));
                                          },
                                          style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              )),
                                          child: Text('리뷰 남겨주기')),
                                    );
                                  } else {
                                    return SizedBox(
                                      height: 40,
                                      width: 200,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            _checkReviewedModal(context, state.users[idx], review);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              )),
                                          child: Text('작성 리뷰 확인하기')),
                                    );
                                  }
                                })
                              ],
                            ),
                          ),
                          Selector<ReviewProvider, List<UserReviewEntity>>(selector: (context, provider) {
                            List<UserReviewEntity> review = [];
                            if (provider.testersReviewOnPost != null) {
                              if (provider.testersReviewOnPost!.isEmpty) return review;
                              review = provider.testersReviewOnPost!
                                  .where((element) => element.reviewedId == state.users[idx].id)
                                  .toList();
                            }
                            return review;
                          }, builder: (context, review, child) {
                            if (review.isNotEmpty) {
                              return Positioned(
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
                              );
                            }
                            return const SizedBox();
                          })
                        ],
                      );
                    },
                    separatorBuilder: (context, idx) => const Gap(10),
                    itemCount: state.users.length);
              }
              return const Center(child: CircularProgressIndicator());
            })));
  }

  String _getPlatform(ApplicationPlatform platform) {
    switch (platform) {
      case ApplicationPlatform.android:
        return 'ANDROID';
      case ApplicationPlatform.ios:
        return 'IOS';
      case ApplicationPlatform.web:
        return 'WEB';
      case ApplicationPlatform.game:
        return 'GAME';
    }
  }

  Future<void> _checkReviewedModal(BuildContext context, UserEntity tester, UserReviewEntity review) {
    _contentController.text = review.comment!;
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei!;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            insetPadding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
                height: hei * 0.6,
                width: MediaQuery.sizeOf(context).width - 40,
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('${tester.nickname}께 전송된 리뷰', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
