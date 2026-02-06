import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:test_us_app/domain/entities/post_review_entity.dart';
import 'package:test_us_app/presentation/bloc/review_bloc/review_state.dart';
import 'package:test_us_app/presentation/bloc/user_bloc/user_event.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';

import '../../../../../data/models/user/user_model.dart';
import '../../../../../domain/entities/recruit_post_entity.dart';
import '../../../../../services/common_height_provider.dart';
import '../../../../../services/theme_provider.dart';
import '../../../../bloc/review_bloc/review_bloc.dart';
import '../../../../bloc/review_bloc/review_event.dart';
import '../../../../bloc/user_bloc/user_bloc.dart';
import '../../../../bloc/user_bloc/user_state.dart';

class CheckPostReviewPage extends StatefulWidget {
  final List<RecruitReviewEntity> reviews;

  const CheckPostReviewPage({super.key, required this.reviews});

  @override
  State<CheckPostReviewPage> createState() => _CheckPostReviewPageState();
}

class _CheckPostReviewPageState extends State<CheckPostReviewPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final token = context.read<UserProvider>().token!;
    context.read<ReviewBloc>().add(RequestPostReviewEvent(token, widget.reviews[0].postId!));
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
      body: BlocConsumer<ReviewBloc, ReviewState>(listener: (context, state) {

      }, builder: (context, state) {
        if(state.state == ReviewDataState.loadingState){
          return SizedBox(
            height: hei,
            width: MediaQuery.sizeOf(context).width,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        else if(state is GetPostReviewState){
          if(state.reviews.isEmpty){
            return SizedBox(
              height: hei,
              width: MediaQuery.sizeOf(context).width,
              child: Center(
                child: Text("리뷰가 없습니다."),
              ),
            );
          }
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
                      final user = state.users.firstWhere((element) => element.id == widget.reviews[idx].reviewerUserId);
                      final isActive = user.status == UserStatus.active;
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
                                      backgroundImage:user.profileImg == null || user.profileImg!.url == null && !isActive
                                          ? const AssetImage('assets/images/Generic avatar.png')
                                          : CachedNetworkImage(imageUrl: user.profileImg!.url!,) as ImageProvider,
                                    ),
                                  ),
                                  const Gap(10),
                                  Text(isActive ? user.nickname! : '알 수 없는 유져', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))
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
                                    Text(state.reviews[idx].comment!, style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                              )
                            ],
                          ));
                    },
                    separatorBuilder: (context, idx) => const Gap(10),
                    itemCount: state.reviews.length),
              ],
            ),
          );
        }
        else{
          return SizedBox(
            height: hei,
            width: MediaQuery.sizeOf(context).width,
            child: Center(
              child: Text("리뷰를 불러올 수 없습니다."),
            ),
          );
        }

      }),
    ));
  }
}
