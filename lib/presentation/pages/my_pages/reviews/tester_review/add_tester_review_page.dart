import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:test_us_app/data/models/package/recruit_post_applications_model.dart';
import 'package:test_us_app/domain/entities/application_entity.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';
import 'package:test_us_app/domain/entities/user_review_entity.dart';
import 'package:test_us_app/presentation/provider/review_provider.dart';

import '../../../../../services/common_height_provider.dart';
import '../../../../bloc/review_bloc/review_bloc.dart';
import '../../../../bloc/review_bloc/review_event.dart';
import '../../../../bloc/review_bloc/review_state.dart';
import '../../../../provider/user_provider.dart';

class AddTesterReviewPage extends StatefulWidget {
  final User tester;
  final int appId;
  const AddTesterReviewPage({super.key, required this.tester, required this.appId});

  @override
  State<AddTesterReviewPage> createState() => _AddTesterReviewPageState();
}

class _AddTesterReviewPageState extends State<AddTesterReviewPage> {

  final TextEditingController _contentController = TextEditingController();
  double _rating = 2.5;

  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei!;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("리뷰 작성"),
        ),
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: BlocListener<ReviewBloc, ReviewState>(
            listener: (context, state) async {
              if(state is CreateUserReviewCompletedState){
                if(state.review.reviewId == null){
                  Get.snackbar('알림', '리뷰가 전송되지 못했어요..');
                  return;
                }
                context.read<ReviewProvider>().updateTesterReview(state.review);
                await _alertDialog(context, widget.tester.nickname!);
              }
              if(state is ReviewDataErrorState || state is ReviewDataFailedState){
                Get.snackbar('알림', '리뷰 전송에 실패했습니다.');
              }
            },
            child: SingleChildScrollView(
              child: Container(
                height: hei,
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      // height: 80,
                      width: MediaQuery.sizeOf(context).width,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("${widget.tester.nickname} 님은\n어떤 테스터 였나요?",
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      )
                    ),
                    SizedBox(
                      height: hei * 0.5,
                      child: Column(
                        children: [
                          RatingBar.builder(
                              initialRating: 2.5,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true ,
                              itemCount: 5,
                              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _){
                            return Icon(Icons.star, color: Colors.amber,);
                          }, onRatingUpdate: (rating){
                                setState(() {
                                  _rating = rating;
                                });
                                // print(_rating);
                          }),
                          const Gap(30),
                          TextField(
                            controller: _contentController,
                            minLines: 10,
                            maxLines: 10,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                            width: 150,
                            child: ElevatedButton(
                                onPressed: (){
                                  try {
                                    final token = context.read<UserProvider>().token!;
                                    final userId = context.read<UserProvider>().user!.id ?? "";

                                    final review = UserReviewEntity(
                                      rating: _rating,
                                      comment: _contentController.text,
                                      reviewerId: userId,
                                      reviewedId: widget.tester.userId!,
                                      applicationId: widget.appId
                                    );

                                    context.read<ReviewBloc>().add(CreateUserReviewEvent(token, review));
                                  } on Exception catch (e) {
                                    // TODO
                                    Get.snackbar('알림', '리뷰 전송에 실패했습니다.');
                                    debugPrint(e.toString());
                                    return;
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                                ),
                                child: Text('리뷰 전송')))
                      ],
                    )
                  ],
                )
              ),
            ),
          ),
        )
      )
    );
  }

  Future<void> _alertDialog(BuildContext context, String nickname) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("리뷰 전송"),
          alignment: Alignment.center,
          content: Text("$nickname님께 리뷰가 전송되었습니다.\n감사합니다.", style: TextStyle(fontSize: 14), textAlign: TextAlign.center,),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (context.mounted) Navigator.pop(context);
                },
                child: Text("확인"))
          ],
        );
      },
    );
  }
}
