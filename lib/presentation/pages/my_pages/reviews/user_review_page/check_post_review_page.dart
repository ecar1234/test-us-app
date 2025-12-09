import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:test_us_app/domain/entities/post_review_entity.dart';
import 'package:test_us_app/presentation/bloc/user_bloc/user_event.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';

import '../../../../../services/common_height_provider.dart';
import '../../../../../services/theme_provider.dart';
import '../../../../bloc/user_bloc/user_bloc.dart';
import '../../../../bloc/user_bloc/user_state.dart';

class CheckPostReviewPage extends StatefulWidget {
  final List<PostReviewEntity> reviews;

  const CheckPostReviewPage({super.key, required this.reviews});

  @override
  State<CheckPostReviewPage> createState() => _CheckPostReviewPageState();
}

class _CheckPostReviewPageState extends State<CheckPostReviewPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final userIds = widget.reviews.map((e) => e.reviewerUserId!).toList();
    final token = context.read<UserProvider>().token!;
    context.read<UserBloc>().add(RequestUsersDataEvent(token, userIds));
  }

  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei!;
    final isDarkMode = context.read<ThemeProvider>().isDarkMode;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("프로덕트 리뷰"),
      ),
      body: BlocConsumer<UserBloc, UserState>(listener: (context, state) {
        if (state.state == UserDataState.getUsersInfoCompletedState) {}
      }, builder: (context, state) {
        if(state.state == UserDataState.loadingState){
          return SizedBox(
            height: hei,
            width: MediaQuery.sizeOf(context).width,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        else if(state.state == UserDataState.getUsersInfoCompletedState){
          return Container(
            height: hei,
            width: MediaQuery.sizeOf(context).width,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [

                ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, idx) {
                      final user = state.users!.firstWhere((element) => element.id == widget.reviews[idx].reviewerUserId);
                      return Container(
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
                              // UserInfo
                              Row(
                                children: [
                                  SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: CircleAvatar(
                                      backgroundImage:user.profileImg == null || user.profileImg!.url == null
                                          ? const AssetImage('assets/images/Generic avatar.png')
                                          : NetworkImage(user.profileImg!.url!),
                                    ),
                                  ),
                                  const Gap(10),
                                  Text(user.nickname!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))
                                ]
                              ),
                              const Gap(10),
                              // Rating builder
                              RatingBar.builder(
                                itemBuilder: (context, idx) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating){},
                                initialRating: widget.reviews[idx].rating!,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                ignoreGestures: true,
                              )
                              // Review content
                              ,const Gap(10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,

                                  children: [
                                    Text(widget.reviews[idx].comment!, style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                              )
                            ],
                          ));
                    },
                    separatorBuilder: (context, idx) => const Gap(10),
                    itemCount: widget.reviews.length),
              ],
            ),
          );
        }
        return SizedBox();

      }),
    ));
  }
}
