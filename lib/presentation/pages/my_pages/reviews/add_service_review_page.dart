import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';

import '../../../../domain/entities/recruit_post_entity.dart';
import '../../../../services/common_height_provider.dart';
import '../../../bloc/review_bloc/review_bloc.dart';
import '../../../bloc/review_bloc/review_state.dart';

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
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei!;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("서비스 리뷰 작성"),
        ),
        body: BlocConsumer<ReviewBloc, ReviewState>(
            listener: (context, state){},
            builder: (context, state){
              return GestureDetector(
                onTap: (){
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  width: MediaQuery.sizeOf(context).width,
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
                          Text('피드백을 남겨 주세요.',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      RatingBar.builder(
                          initialRating: _rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, idx){
                        return Icon(Icons.star, color: Colors.amber,);
                      }, onRatingUpdate: (value){
                        setState(() {
                          _rating = value;
                        });
                      }),
                      SizedBox(
                        height: hei * 0.4,
                        width: MediaQuery.sizeOf(context).width - 40,
                        child: TextField(
                          controller: _commentController,
                          minLines: 20,
                          maxLines: 30,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 150,
                            child: ElevatedButton(
                                onPressed: (){},
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
        )
      )
    );
  }
}
