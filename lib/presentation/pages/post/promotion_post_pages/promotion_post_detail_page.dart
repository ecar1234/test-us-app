import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:test_us_app/domain/entities/promotion_post_entity.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/promotion_bloc/promotion_bloc.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/promotion_bloc/promotion_state.dart';
import 'package:test_us_app/presentation/pages/post/promotion_post_pages/promotion_post_create_page.dart';
import 'package:test_us_app/presentation/provider/post_provider/base_post_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:material_symbols_icons/symbols.dart';



import '../../../../services/common_height_provider.dart';
import '../../../../utils/linkfy_util.dart';
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
        body: BlocConsumer<PromotionBloc, PromotionPostState>(listener: (context, state) {
          final provider = context.read<BasePostProvider>();
          if (state.state == PromotionPostLoadState.postDeleteCompletedState) {
            provider.deletePromotionPost(state.postId!);
            Get.back();
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
    final userId = context.read<UserProvider>().isLogged ?? false ? context.read<UserProvider>().user!.id : "";
    final isAuthor = post.author != null && post.author!.id == userId;
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
            flexibleSpace: FlexibleSpaceBar(
                background: post.images == null || post.images!.isEmpty
                    ? SizedBox(
                        child: Center(
                          child: Text('이미지가 없습니다.'),
                        ),
                      )
                    : CarouselSlider(
                        items: post.images!.map((e) {
                          if (e.filename == null) {
                            return Image.file(
                              File(e.url!),
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            );
                          } else {
                            return Image.network(e.url!,
                                fit: BoxFit.fill, height: double.infinity, width: double.infinity);
                          }
                        }).toList(),
                        options: CarouselOptions(
                          autoPlay: false,
                          viewportFraction: 1.0,
                          height: 250,
                        ),
                      ))),
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
                const Gap(10),
                SizedBox(child: Text(post.subtitle!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                const Gap(10),
                SizedBox(
                  child: Row(
                    children: [
                      if (isAuthor)
                        SizedBox(
                            child: Text(
                          '${post.author!.nickname}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ))
                      else if (post.author == null)
                        SizedBox(
                          child: Text(
                            '${context.read<UserProvider>().user!.nickname}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        )
                      else
                        SizedBox(
                          child: Text(
                            '${post.author!.nickname}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      const Gap(10),
                      SizedBox(
                        child: post.platform!.length == 1
                            ? Text(post.platform![0])
                            : Row(
                                children: [Text(post.platform![0]), const Gap(10), Text(post.platform![1])],
                              ),
                      ),
                      // const Gap(10),
                      // SizedBox(
                      //     child: _post!.createdAt != null
                      //         ? Text(
                      //             '게시일 : ${_post!.createdAt!.year} - ${_post!.createdAt!.month < 10 ?
                      //             '0${_post!.createdAt!.month}' : _post!.createdAt!.month} - ${_post!.createdAt!.day < 10 ?
                      //             '0${_post!.createdAt!.day}' : '${_post!.createdAt!.day}'}',
                      //             style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                      //           )
                      //         : SizedBox()),
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
                            height: 50,
                            width:  80,
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
                                  )
                                ),
                                label: Text(title, style: TextStyle(fontWeight: FontWeight.bold),),
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
}
