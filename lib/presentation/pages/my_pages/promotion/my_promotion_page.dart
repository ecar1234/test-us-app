import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/domain/entities/promotion_post_entity.dart';
import 'package:test_us_app/presentation/pages/post/promotion_post_pages/promotion_post_detail_page.dart';

import '../../../../data/models/post/recruit_post_model.dart';
import '../../../../services/common_height_provider.dart';
import '../../../provider/post_provider/base_post_provider.dart';

class MyPromotionPage extends StatefulWidget {
  const MyPromotionPage({super.key});

  @override
  State<MyPromotionPage> createState() => _MyPromotionPageState();
}

class _MyPromotionPageState extends State<MyPromotionPage> {
  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei!;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("나의 서비스 홍보"),
            ),
            body: Selector<BasePostProvider, List<PromotionPostEntity>>(
                selector: (context, provider) => provider.userPromotionPosts ?? [],
                builder: (context, posts, child) {
                  if (posts.isEmpty) {
                    return SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      height: hei,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('작성 된 모집글이 없습니다.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                          const Gap(10),
                          Text('나만의 서비스가 있다면 테스터를'),
                          Text('모집해 보세요.'),
                        ],
                      ),
                    );
                  }
                  return _itemBuilder(context, posts);
                })));
  }

  Widget _itemBuilder(BuildContext context, List<PromotionPostEntity> posts) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: posts.isEmpty
              ? SizedBox()
              : ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  itemBuilder: (context, idx) {
                    return SizedBox(
                      height: 110,
                      width: MediaQuery.sizeOf(context).width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => PromotionPostDetailPage(post: posts[idx]));
                            },
                            child: Container(
                              width: (MediaQuery.sizeOf(context).width - 50),
                              decoration: BoxDecoration(
                                // border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Flexible(
                                      flex: 3,
                                      child: SizedBox(
                                        height: 110,
                                        width: (MediaQuery.sizeOf(context).width - 50) * 0.3,
                                          child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child:
                                            CachedNetworkImage(imageUrl: posts[idx].images![0].url!, fit: BoxFit.cover),
                                      ))),
                                  const Gap(10),
                                  Flexible(
                                    flex: 7,
                                    child: SizedBox(

                                      width: (MediaQuery.sizeOf(context).width - 50) * 0.7,
                                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                        // title
                                        SizedBox(
                                          height: 30,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                posts[idx].title!,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    overflow: TextOverflow.ellipsis),
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        // platform
                                        SizedBox(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                child: posts[idx].platform!.length == 1
                                                    ? Text('플랫폼 : ${posts[idx].platform![0]}')
                                                    : Text(
                                                        '플랫폼 : ${posts[idx].platform![0]} / ${posts[idx].platform![1]}'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // created at
                                        SizedBox(
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [Text('게시일 : '), Text(_getDate(posts[idx].createdAt!))]),
                                        ),
                                        // expire at
                                        SizedBox(
                                          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                            Text('만료일 : '),
                                            Text(_getDate(posts[idx].createdAt!.add(Duration(days: 7))))
                                          ]),
                                        )
                                      ]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, idx) => const Gap(20),
                  itemCount: posts.length)),
    );
  }

  String _getDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    final second = date.second.toString().padLeft(2, '0');

    return '$year-$month-$day $hour:$minute:$second';
  }
}
