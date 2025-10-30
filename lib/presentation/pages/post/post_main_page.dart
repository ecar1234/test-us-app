import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/presentation/pages/post/tester_post_pages/recruit_post_detail_page.dart';
import 'package:test_us_app/presentation/provider/post_provider/promotion_post_provider.dart';

import '../../../domain/entities/promotion_post_entity.dart';
import '../../../domain/entities/recruit_post_entity.dart';
import '../../../services/common_height_provider.dart';
import '../../bloc/post_blocs/recruit_post_bloc/recruit_post_bloc.dart';
import '../../bloc/post_blocs/recruit_post_bloc/recruit_post_state.dart';
import '../../provider/post_provider/recruit_post_provider.dart';

class PostMainPage extends StatefulWidget {
  final String type;

  const PostMainPage({super.key, required this.type});

  @override
  State<PostMainPage> createState() => _PostMainPageState();
}

class _PostMainPageState extends State<PostMainPage> {
  // late String platform;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecruitPostBloc, RecruitPostState>(builder: (context, state) {
      if (state.state == RecruitPostLoadState.dataLoadState) {
        return SizedBox(child: Center(child: CircularProgressIndicator()));
      }
      // else if (state.state == RecruitPostLoadState.postImgRegisterCompletedState ||
      //     state.state == RecruitPostLoadState.postImgDeleteCompletedState) {
      //   context.read<RecruitPostBloc>().add(RequestCompleteEvent());
      // }

      return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Text("테스터 모집"),
        ),
        body: SingleChildScrollView(
          child: Container(
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: widget.type == 'recruit' ? _recruitSelector()
                  : _promotionSelector()
          ),
        ),
      ));
    });
  }

  Widget _recruitSelector() {
    return Selector<RecruitPostProvider, List<RecruitPostEntity>>(
        selector: (context, provider) => provider.recruitmentPosts ?? [],
        builder: (context, posts, child) {
          return _postListBuilder(context, posts);
        });
  }

  Widget _promotionSelector() {
    return Selector<PromotionPostProvider, List<PromotionPostEntity>>(
        selector: (context, provider) => provider.promotionPosts ?? [],
        builder: (context, posts, child) {
          return _postListBuilder(context, posts);
        });
  }
  // TODO: post type에 따라서 detail page의 전환 방법을 설정해야 함.
  Widget _postListBuilder(BuildContext context, List<dynamic> posts) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei ?? MediaQuery.sizeOf(context).height - 120;
    return SizedBox(
        width: MediaQuery.sizeOf(context).width - 40,
        // height: hei - 40,
        child: posts.isEmpty
            ? SizedBox(height: hei, child: Center(child: Text("테스터 모집이 아직 없습니다.")))
            : Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 30, bottom: 30),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 30,
                mainAxisSpacing: 30,
                mainAxisExtent: 280,
                // childAspectRatio: 0.5
              ),
              itemBuilder: (context, idx) {
                return GestureDetector(
                  onTap: () async {
                    // context.read<DataBloc>().add(PostDataLoadEvent());
                    // final token = context.read<UserProvider>().token ?? "";
                    // final res = await context.read<PostProvider>().getPostById(token, posts[idx].id!);
                    // if(context.mounted) context.read<DataBloc>().add(RequestPostDataEvent(res));
                    Get.to(() => PostDetailPage(postId: posts[idx].id!,));
                  },
                  child: SizedBox(
                    child: Column(
                      children: [
                        Flexible(
                            flex: 1,
                            child: Container(
                              height: 138,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: posts[idx].images!.isEmpty ? Border.all() : null),
                              child: posts[idx].images!.isEmpty
                                  ? SizedBox(
                                child: Center(
                                  child: Text('이미지가 없습니다.'),
                                ),
                              )
                                  : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  posts[idx].images![0].url!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )),
                        const Gap(4),
                        Flexible(
                            flex: 1,
                            child: SizedBox(
                              height: 137,
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text("${posts[idx].title}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  const Gap(4),
                                  Text("${posts[idx].subtitle}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                                  const Gap(4),
                                  Text("${posts[idx].author!.nickname}")
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                );
              },
              itemCount: posts.length,
            ),
          ],
        ));
  }
}
