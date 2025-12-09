import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:test_us_app/data/models/review/post_review_model.dart';
import 'package:test_us_app/presentation/bloc/review_bloc/review_event.dart';
import 'package:test_us_app/presentation/provider/application_provider.dart';
import 'package:test_us_app/presentation/provider/post_provider/recruit_post_provider.dart';
import 'package:test_us_app/presentation/provider/review_provider.dart';

import '../../../../../domain/entities/post_review_entity.dart';
import '../../../../../domain/entities/recruit_post_entity.dart';
import '../../../../../services/common_height_provider.dart';
import '../../../../bloc/review_bloc/review_bloc.dart';
import '../../../../bloc/review_bloc/review_state.dart';
import '../../../../provider/user_provider.dart';

class AddServiceReviewPage extends StatefulWidget {
  final RecruitPostEntity post;

  const AddServiceReviewPage({super.key, required this.post});

  @override
  State<AddServiceReviewPage> createState() => _AddServiceReviewPageState();
}

class _AddServiceReviewPageState extends State<AddServiceReviewPage> {
  double _rating = 2.5;
  final TextEditingController _commentController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I
        .get<ResponsiveHeightProvider>()
        .hei!;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("서비스 리뷰 작성"),
            ),
            body: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              behavior: HitTestBehavior.opaque,
              child: BlocConsumer<ReviewBloc, ReviewState>(
                  listener: (context, state) {
                    if(state is CreateRecruitPostReviewCompletedState){
                      context.read<ApplicationProvider>().addReviewToUserApplicationPost(state.review);
                      _alertDialog(context);
                    }
                  },
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: Container(
                        height: hei,
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        width: MediaQuery
                            .sizeOf(context)
                            .width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                RichText(text: TextSpan(text: '${widget.post.title}',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87,
                                        overflow: TextOverflow.ellipsis),
                                    children: [
                                      TextSpan(text: ' 은(는)')
                                    ])),
                                Text('어떤 서비스 였나요?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                Text('피드백을 남겨 주세요.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            RatingBar.builder(
                                initialRating: _rating,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, idx) {
                                  return Icon(Icons.star, color: Colors.amber,);
                                },
                                onRatingUpdate: (value) {
                                  setState(() {
                                    _rating = value;
                                  });
                                }),
                            SizedBox(
                              height: hei * 0.4,
                              width: MediaQuery
                                  .sizeOf(context)
                                  .width - 40,
                              child: TextField(
                                controller: _commentController,
                                minLines: 20,
                                maxLines: 20,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: 50,
                                    width: 150,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          final token = context
                                              .read<UserProvider>()
                                              .token!;
                                          final userId = context
                                              .read<UserProvider>()
                                              .user!.id!;
                      
                                          final review = PostReviewEntity(
                                            rating: _rating,
                                            comment: _commentController.text,
                                            reviewType: PostReviewType.recruit,
                                            reviewerUserId: userId,
                                            // reviewedId: widget.post.author!.id!,
                                            postId: widget.post.id!,
                                          );
                                          context.read<ReviewBloc>().add(CreateRecruitPostReviewEvent(token, review));
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                                        ),
                                        child: Text('리뷰 전송')
                                    )
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }
              ),
            )
        )
    );
  }

  Future<void> _alertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("피드백 전송"),
          alignment: Alignment.center,
          content: Text("개발자님께 피드백이 전송되었습니다.\n감사합니다.", style: TextStyle(fontSize: 14), textAlign: TextAlign.center,),
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
