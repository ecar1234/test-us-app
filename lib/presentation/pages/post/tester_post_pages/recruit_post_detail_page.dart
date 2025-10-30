import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/data/models/application/application_model.dart';
import 'package:test_us_app/domain/entities/application_entity.dart';
import 'package:test_us_app/presentation/bloc/app_bloc/app_event.dart';
import 'package:test_us_app/presentation/bloc/app_bloc/app_state.dart';
import 'package:test_us_app/presentation/pages/post/tester_post_pages/recruit_post_create_page.dart';
import 'package:test_us_app/presentation/provider/application_provider.dart';
import 'package:test_us_app/presentation/provider/post_provider/recruit_post_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:test_us_app/utils/linkfy_util.dart';
import 'package:test_us_app/utils/play_store_linkify_util.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../domain/entities/recruit_post_entity.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../bloc/app_bloc/app_bloc.dart';
import '../../../bloc/post_blocs/recruit_post_bloc/recruit_post_bloc.dart';
import '../../../bloc/post_blocs/recruit_post_bloc/recruit_post_event.dart';
import '../../../bloc/post_blocs/recruit_post_bloc/recruit_post_state.dart';
import '../../../components/login_dialogs.dart';
import '../../../provider/post_provider/base_post_provider.dart';


class PostDetailPage extends StatefulWidget {
  final RecruitPostEntity? post;
  final String? postId;

  const PostDetailPage({super.key, this.post, this.postId});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final logger = Logger();
  @override
  void initState() {
    super.initState();
    if (widget.post == null && widget.postId != null) {
      final token = context.read<UserProvider>().token ?? '';
      context.read<RecruitPostBloc>().add(RequestPostDataEvent(token, widget.postId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecruitPostBloc, RecruitPostState>(listener: (context, state) {
      final provider = context.read<BasePostProvider>();
      if(state.state == RecruitPostLoadState.getPostByIdCompletedState){

      }else if(state.state == RecruitPostLoadState.postDeleteCompletedState){
        provider.deleteRecruitPost(state.post!.id!);
        Navigator.pop(context);
      }else if(state.state == RecruitPostLoadState.postUpdateCompletedState){
        provider.updateRecruitPost(state.post!);
        Navigator.pop(context);
      }
    }, builder: (context, state) {
      final hei = GetIt.instance.get<ResponsiveHeightProvider>().hei!;
      if(widget.post != null){
        return _postInfoBuilder(widget.post!, hei);
      }
      if (state.state == RecruitPostLoadState.dataLoadState) {
        return Scaffold(
          body: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: hei,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      }
      if(state.state == RecruitPostLoadState.getPostByIdCompletedState
          || state.state == RecruitPostLoadState.postUpdateCompletedState){
        return _postInfoBuilder(state.post!, hei);
      }
      return Scaffold(
        body: SizedBox(
          height: hei,
          width: MediaQuery.sizeOf(context).width,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    });
  }

  Widget _postInfoBuilder(RecruitPostEntity post, double hei){
    final userId = context.read<UserProvider>().isLogged ?? false ? context.read<UserProvider>().user!.id : "";
    final isAuthor = post.author != null && post.author!.id == userId;
    return SafeArea(
        child: Scaffold(
          body: CustomScrollView(
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
                              return RecruitPostCreatePage(post: post);
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
                                    context.read<RecruitPostBloc>().add(RequestPostDeleteEvent(token, post));
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
                          if (e.id == null) {
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
              // test code
              // if (_post == null)
              //   SliverList(
              //       key: const ValueKey("nullValue"),
              //       delegate: SliverChildBuilderDelegate(
              //         (context, index) => SizedBox(
              //           height: 100,
              //           child: Card(
              //             child: Text(index.toString()),
              //           ),
              //         ),
              //         childCount: 30,
              //       ))
              // else
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
                      SizedBox(
                          child: Text(post.subtitle!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
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
                            else if ( post.author == null)
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
                      if (post.author != null && post.author!.id != userId)
                        BlocConsumer<AppBloc, AppState>(
                          listener: (context, state) {
                            if (state.state == UserAppState.applicationCompletedState) {
                              context.read<ApplicationProvider>().requestApply(state.application!);
                            }else if(state.state == UserAppState.applicationUpdateCompletedState){
                              context.read<ApplicationProvider>().requestUpdateApplication(state.application!);
                            }
                            else if (state.state == UserAppState.applicationCancelCompletedState) {
                              context.read<ApplicationProvider>().cancelApplication(state.application!);
                            }
                          },
                            builder: (context, state) {
                          final isLogged = context.watch<UserProvider>().isLogged??false;
                          final applications = context.read<ApplicationProvider>().applications ?? [];
                          final user = context.read<UserProvider>().user ?? UserEntity();

                          final app = applications.firstWhere((e) => e.postId == post.id && e.applicantId == user.id,
                              orElse: () => ApplicationEntity());

                          return _applicationSection(isLogged, post, app);
                        })
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget _applicationSection(bool isLogged, RecruitPostEntity post, ApplicationEntity application) {
    if (!isLogged) return _beforeApplicationSection(post);

    // 신청 내역이 없는 경우
    if (application.id == null) return _beforeApplicationSection(post);

    switch (application.status) {
      case ApplicationStatus.pending:
      case ApplicationStatus.accepted:
        return _afterApplicationSection(post);
      case ApplicationStatus.rejected:
        return _rejectedApplicationSection();
      default:
        return _beforeApplicationSection(post);
    }
  }

  Widget _afterApplicationSection(RecruitPostEntity post) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      if (state.state == UserAppState.requestCompletedState) {
        context.read<RecruitPostBloc>().add(ReloadPostEvent());
        context.read<AppBloc>().add(RequestCompletedEvent());
      }
      return SizedBox(
          height: 180,
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Selector<ApplicationProvider, ApplicationEntity>(
                selector: (context, provider) => provider.applications!.firstWhere((e) => e.postId == post.id),
                builder: (context, app, child) => SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () async {
                        final token = context.read<UserProvider>().token ?? '';
                        final appId = context.read<ApplicationProvider>().applications!.firstWhere((element) {
                          return element.postId == post.id;
                        }).id!;

                        context.read<AppBloc>().add(RequestCancelEvent(token, appId));
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      child: Text('신청 취소 ${app.status == ApplicationStatus.pending ? '(대기 중)' : '(테스트 중)'}')),
                ),
              ),
              const Gap(20),
              if (post.platform!.contains('IOS') || post.platform!.contains('ANDROID'))
                SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            barrierColor: null,
                            builder: (context) {
                              bool isIos = false;
                              bool isAndroid = false;

                              final prevApp = context.read<ApplicationProvider>().applications!.firstWhere((element) {
                                return element.postId == post.id &&
                                    element.applicantId == context.read<UserProvider>().user!.id;
                              });
                              if (prevApp.platform == ApplicationPlatform.ios) {
                                isIos = true;
                                isAndroid = false;
                              }
                              if (prevApp.platform == ApplicationPlatform.android) {
                                isAndroid = true;
                                isIos = false;
                              }

                              return StatefulBuilder(
                                builder: (context, state) => Container(
                                    height: 300,
                                    width: MediaQuery.sizeOf(context).width,
                                    padding: EdgeInsets.all(20),
                                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                      SizedBox(
                                          child: Text('테스트 진행 할 플랫폼을 선택해 주세요.',
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                                      const Gap(20),
                                      SizedBox(
                                          child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            child: Row(children: [
                                              Checkbox(
                                                  value: isIos,
                                                  onChanged: (value) {
                                                    state(() {
                                                      isIos = value!;
                                                      isAndroid = false;
                                                    });
                                                  }),
                                              Text("IOS")
                                            ]),
                                          ),
                                          SizedBox(
                                            child: Row(children: [
                                              Checkbox(
                                                  value: isAndroid,
                                                  onChanged: (value) {
                                                    state(() {
                                                      isAndroid = value!;
                                                      isIos = false;
                                                    });
                                                  }),
                                              Text("Android")
                                            ]),
                                          )
                                        ],
                                      )),
                                      const Gap(20),
                                      SizedBox(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            final token = context.read<UserProvider>().token ?? '';
                                            final userId = context.read<UserProvider>().user!.id;
                                            final app = ApplicationEntity(
                                                id: prevApp.id,
                                                platform:
                                                    isAndroid ? ApplicationPlatform.android : ApplicationPlatform.ios,
                                                status: ApplicationStatus.pending,
                                                postId: post.id,
                                                applicantId: userId);

                                            context.read<AppBloc>().add(RequestUpdateApplicationEvent(token, app));
                                            if (context.mounted) Navigator.pop(context);
                                          },
                                          child: Text("신청하기"),
                                        ),
                                      ),
                                    ])),
                              );
                            });
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      child: Text('플랫폼 변경')),
                ),
              const Gap(40)
            ],
          ));
    });
  }

  Widget _beforeApplicationSection(RecruitPostEntity post) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      if (state.state == UserAppState.requestCompletedState) {
        context.read<RecruitPostBloc>().add(ReloadPostEvent());
        context.read<AppBloc>().add(RequestCompletedEvent());
      }
      return Center(
        child: SizedBox(
          height: 50,
          width: MediaQuery.sizeOf(context).width - 80,
          child: ElevatedButton(
            onPressed: () async {
              final isLogged = context.read<UserProvider>().isLogged??false;
              if (!isLogged) {
                showDialog(context: context, builder: (context) => LoginDialog());
                return;
              }

              final token = context.read<UserProvider>().token ?? '';
              final userId = isLogged ? context.read<UserProvider>().user!.id : '';
              final application = context.read<ApplicationProvider>().applications!.firstWhere((e) => e.postId == post.id! &&
              e.applicantId == userId, orElse: () => ApplicationEntity());

              if (post.platform!.contains('WEB') || post.platform!.contains('GAME')) {
                if(application.id != null && application.status == ApplicationStatus.cancel){
                  final prevApp = application;
                  final app = ApplicationEntity(
                      id: prevApp.id,
                      platform: prevApp.platform,
                      postId: post.id,
                      status: ApplicationStatus.pending,
                      applicantId: userId);

                  context.read<AppBloc>().add(RequestUpdateApplicationEvent(token, app));
                }else {
                  final platform = post.platform!.contains('WEB') ? ApplicationPlatform.web : ApplicationPlatform.game;
                  // context.read<AppBloc>().add(ApplicationDataLoadEvent());
                  final app = ApplicationEntity(
                      platform: platform,
                      status: ApplicationStatus.pending,
                      postId: post.id, applicantId: userId);

                  context.read<AppBloc>().add(RequestApplyEvent(token, app));
                }
              } else {
                showModalBottomSheet(
                    context: context,
                    barrierColor: null,
                    builder: (context) {
                      bool isIos = false;
                      bool isAndroid = false;

                      return StatefulBuilder(
                        builder: (context, state) => Container(
                            height: 300,
                            width: MediaQuery.sizeOf(context).width,
                            padding: EdgeInsets.all(20),
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              SizedBox(
                                  child: Text('테스트 진행 할 플랫폼을 선택해 주세요.',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                              const Gap(20),
                              SizedBox(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    child: Row(children: [
                                      Checkbox(
                                          value: isIos,
                                          onChanged: (value) {
                                            state(() {
                                              isIos = value!;
                                              isAndroid = false;
                                            });
                                          }),
                                      Text("IOS")
                                    ]),
                                  ),
                                  SizedBox(
                                    child: Row(children: [
                                      Checkbox(
                                          value: isAndroid,
                                          onChanged: (value) {
                                            state(() {
                                              isAndroid = value!;
                                              isIos = false;
                                            });
                                          }),
                                      Text("Android")
                                    ]),
                                  )
                                ],
                              )),
                              const Gap(20),
                              SizedBox(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    // context.read<AppBloc>().add(ApplicationDataLoadEvent());
                                    if (application.id != null && application.status == ApplicationStatus.cancel) {
                                      final prevApp = application;

                                      final app = ApplicationEntity(
                                          id: prevApp.id,
                                          platform: isAndroid ? ApplicationPlatform.android : ApplicationPlatform.ios,
                                          postId: post.id,
                                          status: ApplicationStatus.pending,
                                          applicantId: userId);

                                      context.read<AppBloc>().add(RequestUpdateApplicationEvent(token, app));
                                    } else {
                                      final app = ApplicationEntity(
                                          platform: isAndroid ? ApplicationPlatform.android : ApplicationPlatform.ios,
                                          postId: post.id,
                                          applicantId: userId);

                                      context.read<AppBloc>().add(RequestApplyEvent(token, app));
                                    }
                                    if (context.mounted) Navigator.pop(context);
                                  },
                                  child: Text("신청하기"),
                                ),
                              ),
                            ])),
                      );
                    });
              }
            },
            style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: Text("테스터 신청"),
          ),
        ),
      );
    });
  }

  Widget _rejectedApplicationSection() {
    return SizedBox(
        height: 50,
        width: MediaQuery.sizeOf(context).width,
        child: Row(
          children: [
            SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                  onPressed: null,
                  style:
                      ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: Text("테스터 신청에 거부된 모집입니다.")),
            )
          ],
        ));
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
