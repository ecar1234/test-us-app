import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:test_us_app/domain/entities/promotion_post_entity.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/promotion_bloc/promotion_bloc.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/promotion_bloc/promotion_state.dart';
import 'package:test_us_app/presentation/pages/post/promotion_post_pages/promotion_post_create_page.dart';
import 'package:test_us_app/presentation/provider/post_provider/base_post_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../data/models/application/application_model.dart';
import '../../../../domain/entities/image_entity.dart';
import '../../../../services/common_height_provider.dart';
import '../../../../utils/linkfy_util.dart';
import '../../../../utils/type_conversion_util.dart';
import '../../../bloc/post_blocs/promotion_bloc/promotion_event.dart';
import '../../../provider/user_provider.dart';

class PromotionPostDetailPage extends StatefulWidget {
  final String? postId;
  final PromotionPostEntity? post;

  const PromotionPostDetailPage({super.key, this.postId, this.post});

  @override
  State<PromotionPostDetailPage> createState() => _PromotionPostDetailPageState();
}

class _PromotionPostDetailPageState extends State<PromotionPostDetailPage> {
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    if (widget.post == null && widget.postId != null) {
      final token = context.read<UserProvider>().token ?? '';
      context.read<PromotionBloc>().add(RequestPromotionPostDataEvent(token, widget.postId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final hei = GetIt.instance.get<ResponsiveHeightProvider>().hei!;
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<PromotionBloc, PromotionPostState>(
            listener: (context, state) {
          final provider = context.read<BasePostProvider>();
          if (state.state == PromotionPostLoadState.postDeleteCompletedState) {
            provider.deletePromotionPost(state.postId!);
            Get.back();
          }
          else if(state.state == PromotionPostLoadState.getPostByIdCompletedState||
              state.state == PromotionPostLoadState.postUpdateCompletedState){
            provider.updateUserPromotionPosts(state.post!);
          }
        }, builder: (context, state) {
          if (widget.post != null) {
            return _buildPostInfo(context, widget.post!, hei);
          }
          if (state.state == PromotionPostLoadState.postLoadingState) {
            return SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: hei,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state.state == PromotionPostLoadState.getPostByIdCompletedState ||
              state.state == PromotionPostLoadState.postUpdateCompletedState) {
            return _buildPostInfo(context, state.post!, hei);
          } else if (state.state == PromotionPostLoadState.errorState) {
            return SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: hei,
              child: Center(
                child: Text('알 수 없는 오류 발생.'),
              ),
            );
          }
          return SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: hei,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPostInfo(BuildContext context, PromotionPostEntity post, double hei) {
    final user = context.read<UserProvider>().isLogged ?? false ? context.read<UserProvider>().user : null;
    final isAuthor = post.author != null && post.author!.id == user?.id;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
            expandedHeight: hei * 0.3,
            pinned: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios_new),
            ),
            actions: [
              isAuthor
                  ? PopupMenuButton(
                      icon: Icon(Icons.more_vert_rounded),
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(value: 1, child: Text("수정하기")),
                          PopupMenuItem(value: 2, child: Text("삭제하기"))
                        ];
                      },
                      onSelected: (value) async {
                        if (value == 1) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return PromotionPostCreatePage(post: post);
                          }));
                        } else if (value == 2) {
                          Get.defaultDialog(title: "알림", middleText: "삭제된 게시글은 복구 할 수 없습니다.\n삭제하시겠습니까?", actions: [
                            ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text("취소"),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final token = context.read<UserProvider>().token ?? "";
                                try {
                                  context.read<PromotionBloc>().add(RequestPostDeleteEvent(token, post.id!));
                                } on Exception catch (e) {
                                  Get.snackbar('알림', '삭제 실패');
                                  logger.e(e.toString());
                                  return;
                                }
                                Get.back();
                              },
                              child: Text("확인"),
                            )
                          ]);
                        }
                      },
                    )
                  : SizedBox()
            ],
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final percent = (constraints.biggest.height - kToolbarHeight) / 100;
                final opacity = percent.clamp(0.0, 1.0);
                return FlexibleSpaceBar(
                    title: Opacity(
                        opacity: 1 - opacity,
                        child: Text(
                          post.title!,
                          overflow: TextOverflow.ellipsis,
                        )),
                    background: _buildImages(post.images!));
              },
            )),
        SliverToBoxAdapter(
          key: const ValueKey("postValue"),
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    child: Text(
                  post.title!,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                )),
                const Gap(5),
                SizedBox(child: Text(post.subtitle!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                const Gap(5),
                Row(
                  children: [
                    Text("카테고리"),
                    const Gap(10),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          TypeConversionUtil().postCategoryToString(post.category!),
                        )),
                  ],
                ),
                Row(children: [
                  Text("플랫폼"),
                  const Gap(10),
                  Text(post.platform!.name.toUpperCase()),
                  const Gap(5),
                  if (post.platform! == ApplicationPlatform.mobile)
                    SizedBox(
                      child: Text(
                        "( ${TypeConversionUtil().getPostOs(post.mobileOs!)} )",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey.shade600,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                ]),
                const Gap(10),
                SizedBox(
                  child: Row(
                    children: [
                      SizedBox(
                          child: Row(
                        children: [
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: CircleAvatar(
                                radius: 40,
                                backgroundImage: post.author!.profileImg == null
                                    ? const AssetImage('assets/images/Generic avatar.png')
                                    : CachedNetworkImageProvider(
                                        post.author!.profileImg!.url!,
                                      ) as ImageProvider),
                          ),
                          const Gap(5),
                          Text(
                            '${post.author!.nickname}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
                const Divider(),
                const Gap(30),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: hei * 0.35,
                  ),
                  child: SizedBox(
                      // height: constraints.maxHeight * 0.5,
                      child: Linkify(
                    text: post.contents!,
                    // linkifiers: [WwwLinkifier(), PlayStoreLinkifier()],
                    linkifiers: [WwwLinkifier()],
                    linkStyle: const TextStyle(color: Colors.blue),
                    onOpen: _linkOpen,
                  )),
                ),
                const Gap(40),
                SizedBox(
                    child: ListView.separated(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, idx) {
                          String title = '';
                          if (post.domain![idx].contains('apps.apple.com')) {
                            title = 'App Store 에서 다운로드';
                          } else if (post.domain![idx].contains('play.google.com')) {
                            title = 'Google Play 에서 다운로드';
                          } else {
                            title = 'URL 접속하기';
                          }
                          return SizedBox(
                            height: 40,
                            // width:  80,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                String url = post.domain![idx];
                                if (!url.startsWith('http')) {
                                  url = 'https://$url';
                                }
                                final uri = Uri.parse(url);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri, mode: LaunchMode.platformDefault);
                                } else {
                                  Get.snackbar('연결 실패', '접속할 수 없거나 존재하지 않는 주소입니다.');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              label: Text(
                                title,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              icon: Icon(Symbols.download),
                              iconAlignment: IconAlignment.end,
                            ),
                          );
                        },
                        separatorBuilder: (context, idx) => const Gap(16),
                        itemCount: post.domain!.length))
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<void> _linkOpen(LinkableElement link) async {
    final uri = Uri.parse(link.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('알림', '존재하지 않는 주소입니다.');
    }
  }

  Widget _buildImages(List<ImageEntity> images) {
    if (images.length == 1) {
      if (images[0].isLocal == true) {
        return Image.file(
          File(images[0].url!),
          fit: BoxFit.fitHeight,
          height: double.infinity,
          width: double.infinity,
        );
      } else {
        return CachedNetworkImage(
          imageUrl: images[0].url!,
          fit: BoxFit.fitHeight,
          height: double.infinity,
          width: double.infinity,
        );
      }
    } else {
      return CarouselSlider(
        items: images.map((e) {
          if (e.isLocal == true) {
            return Image.file(
              File(e.url!),
              fit: BoxFit.fitHeight,
              height: double.infinity,
              width: double.infinity,
            );
          } else {
            return CachedNetworkImage(
                imageUrl: e.url!,
                fit: BoxFit.fitHeight,
                height: double.infinity,
                width: double.infinity,
                progressIndicatorBuilder: (context, url, downloadProgress) {
                  return Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.white,
                      ));
                });
          }
        }).toList(),
        options: CarouselOptions(
          autoPlay: false,
          viewportFraction: 1.0,
          height: 250,
        ),
      );
    }
  }
}
