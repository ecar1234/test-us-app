import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/promotion_bloc/promotion_event.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/promotion_bloc/promotion_state.dart';
import 'package:test_us_app/presentation/pages/post/promotion_post_pages/promotion_post_detail_page.dart';
import 'package:test_us_app/presentation/pages/post/tester_post_pages/recruit_post_detail_page.dart';
import 'package:test_us_app/presentation/provider/post_provider/promotion_post_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';

import '../../../domain/entities/promotion_post_entity.dart';
import '../../../domain/entities/recruit_post_entity.dart';
import '../../../services/common_height_provider.dart';
import '../../bloc/post_blocs/promotion_bloc/promotion_bloc.dart';
import '../../bloc/post_blocs/recruit_post_bloc/recruit_post_bloc.dart';
import '../../bloc/post_blocs/recruit_post_bloc/recruit_post_event.dart';
import '../../bloc/post_blocs/recruit_post_bloc/recruit_post_state.dart';
import '../../provider/post_provider/recruit_post_provider.dart';

class PostMainPage extends StatefulWidget {
  final String type;

  const PostMainPage({super.key, required this.type});

  @override
  State<PostMainPage> createState() => _PostMainPageState();
}

class _PostMainPageState extends State<PostMainPage> {
  int page = 0;

  @override
  void initState() {
    // TODO: 스크롤에 비례한 페이지네이션 추가가 필요함.
    // NOTE: page는 pagination이 호출될때 1씩 증가한다.
    super.initState();
    page++;
    widget.type == 'recruit'
        ? context.read<RecruitPostBloc>().add(RequestRecruitmentPaginationEvent(page, 20))
        : context.read<PromotionBloc>().add(RequestPromotionPaginationEvent(page, 20));
  }

  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei ?? MediaQuery.sizeOf(context).height - 120;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(widget.type == 'recruit' ? '테스터 모집' : '서비스 홍보'),
      ),
      body: SingleChildScrollView(
        child: Container(
            width: MediaQuery.sizeOf(context).width,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: widget.type == 'recruit' ? _recruitSelector(context, hei) : _promotionSelector(context, hei)),
      ),
    ));
  }

  Widget _recruitSelector(context, double hei) {
    return BlocListener<RecruitPostBloc, RecruitPostState>(
        listener: (context, state) {
          final provider = context.read<RecruitPostProvider>();
          if (state.state == RecruitPostLoadState.getPostByIdCompletedState) {
            provider.getPostPagination(state.posts!, state.page);
            page++;
          }
        },
        child: Selector<RecruitPostProvider, List<RecruitPostEntity>>(
            selector: (context, provider) => provider.recruitmentPosts ?? [],
            builder: (context, posts, child) {

              return _postListBuilder(context, posts);
            }));
  }

  Widget _promotionSelector(context, double hei) {
    return BlocListener<PromotionBloc, PromotionPostState>(listener: (context, state) {
      final provider = context.read<PromotionPostProvider>();
      if (state.state == PromotionPostLoadState.getPostByIdCompletedState) {
        provider.getPagination(state.posts!, state.page!);
        page++;
      }
    }, child: Selector<PromotionPostProvider, List<PromotionPostEntity>>(
        selector: (context, provider) => provider.promotionPosts ?? [],
        builder:(context, posts, child) {
          return _postListBuilder(context, posts);
        }));

  }

  Widget _postListBuilder(BuildContext context, List<dynamic> posts) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei ?? MediaQuery.sizeOf(context).height - 120;
    return SizedBox(
        width: MediaQuery.sizeOf(context).width - 40,
        // height: hei - 40,
        child: posts.isEmpty
            ? SizedBox(
                height: hei,
                child: Center(child: Text(widget.type == 'recruit' ? "테스터 모집이 아직 없습니다." : '서비스 홍보가 아직 없습니다.')))
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
                          widget.type == 'recruit'
                              ? Get.to(() => RecruitPostDetailPage(
                                    postId: posts[idx].id!,
                                  ))
                              : Get.to(() => PromotionPostDetailPage(postId: posts[idx].id!));
                        },
                        child: SizedBox(
                          child: Column(
                            children: [
                              Flexible(
                                  flex: 1,
                                  child: Container(
                                    height: 138,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: posts[idx].images!.isEmpty ? Border.all() : null),
                                    child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl: posts[idx].images![0].url!,
                                              fit: BoxFit.cover,
                                              progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                                  child: SizedBox(
                                                      height: 50,
                                                      width: 50,
                                                      child:
                                                          CircularProgressIndicator(value: downloadProgress.progress))),
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
