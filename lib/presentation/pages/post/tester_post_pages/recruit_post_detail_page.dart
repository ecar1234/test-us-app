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
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
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
import 'package:url_launcher/url_launcher.dart';

import '../../../../domain/entities/image_entity.dart';
import '../../../../domain/entities/recruit_post_entity.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../utils/type_conversion_util.dart';
import '../../../bloc/app_bloc/app_bloc.dart';
import '../../../bloc/post_blocs/recruit_post_bloc/recruit_post_bloc.dart';
import '../../../bloc/post_blocs/recruit_post_bloc/recruit_post_event.dart';
import '../../../bloc/post_blocs/recruit_post_bloc/recruit_post_state.dart';
import '../../../components/login_dialogs.dart';
import '../../../provider/post_provider/base_post_provider.dart';

class RecruitPostDetailPage extends StatefulWidget {
  final RecruitPostEntity? post;
  final String? postId;

  const RecruitPostDetailPage({super.key, this.post, this.postId});

  @override
  State<RecruitPostDetailPage> createState() => _RecruitPostDetailPageState();
}

class _RecruitPostDetailPageState extends State<RecruitPostDetailPage> {
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
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<RecruitPostBloc, RecruitPostState>(listener: (context, state) async {
          final provider = context.read<BasePostProvider>();
          if (state.state == RecruitPostLoadState.getPostByIdCompletedState) {
          } else if (state.state == RecruitPostLoadState.postDeleteCompletedState) {
            provider.deleteRecruitPost(state.post!.id!);
            Navigator.pop(context);
          } else if (state.state == RecruitPostLoadState.postUpdateCompletedState) {
            provider.updateRecruitPost(state.post!);
            Navigator.pop(context);
          } else if (state.state == RecruitPostLoadState.errorState && state.post == null) {
            await showDialog(
                context: context,
                builder: (context) => Dialog(
                      child: Container(
                          height: 200,
                          width: MediaQuery.sizeOf(context).width,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '게시글이 삭제 되었거나, 존재하지 않습니다.',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              const Gap(20),
                              SizedBox(
                                height: 40,
                                width: 120,
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: Text('뒤로가기')),
                              )
                            ],
                          )),
                    ));
          }
        }, builder: (context, state) {
          final hei = GetIt.instance.get<ResponsiveHeightProvider>().hei!;
          if (widget.post != null) {
            return _postInfoBuilder(widget.post!, hei);
          }
          if (state.state == RecruitPostLoadState.dataLoadState) {
            return SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: hei,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state.state == RecruitPostLoadState.getPostByIdCompletedState ||
              state.state == RecruitPostLoadState.postUpdateCompletedState) {
            return _postInfoBuilder(state.post!, hei);
          }
          return SizedBox(
            height: hei,
            width: MediaQuery.sizeOf(context).width,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }),
      ),
    );
  }

  Widget _postInfoBuilder(RecruitPostEntity post, double hei) {
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
                if (post.author != null && post.author!.id != user?.id)
                  BlocListener<AppBloc, AppState>(
                      listener: (context, state) {
                        if (state.state == UserAppState.applicationCompletedState) {
                          context.read<ApplicationProvider>().requestApply(state.application!);
                        }
                        if (state.state == UserAppState.applicationUpdateCompletedState) {
                          context.read<ApplicationProvider>().requestUpdateApplication(state.application!);
                        }
                        if (state.state == UserAppState.applicationCancelCompletedState) {
                          context.read<ApplicationProvider>().cancelApplication(state.application!);
                        }
                        context.read<BasePostProvider>().updateRecruitPost(state.post!);
                      },
                      child: _applicationSection(context, post)),
                const Gap(40)
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _applicationSection(BuildContext context, RecruitPostEntity post) {
    final isLogged = context.watch<UserProvider>().isLogged ?? false;

    // if (app.id == null) return _beforeApplicationSection(context, initPostData);
    return Selector<ApplicationProvider, ApplicationEntity>(selector: (context, provider) {
      final app = provider.userApplications!.firstWhere((e) => e.postId == widget.postId!, orElse: () => ApplicationEntity());
      return app;
    }, builder: (context, application, child) {
      if (!isLogged) return _beforeApplicationSection(context, post);

      // final applications = context.read<ApplicationProvider>().userApplications ?? [];
      // final user = context.read<UserProvider>().user!;
      // final app = applications.firstWhere((e) => e.postId == post.id && e.applicantId == user.id,
      //     orElse: () => ApplicationEntity());
// todo : 신청은 정상 작동, 취소 시 새로 받아오는 post application state가 pending으로 나옴(서버 확인)
// todo : 서버에서 mobileOs가 DB에 저장 안됨(서버확인
      switch (application.status) {
        case ApplicationStatus.pending:
        case ApplicationStatus.accepted:
          return _afterApplicationSection(context, post);
        case ApplicationStatus.rejected:
          return _rejectedApplicationSection(context);
        default:
          return _beforeApplicationSection(context, post);
      }
    });
  }

  Widget _afterApplicationSection(BuildContext context, RecruitPostEntity post) {
    if (post.platform! == ApplicationPlatform.web) {
      return SizedBox(
          height: 60,
          width: MediaQuery.sizeOf(context).width - 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Selector<ApplicationProvider, ApplicationEntity>(
                selector: (context, provider) => provider.userApplications!.firstWhere((e) => e.postId == post.id),
                builder: (context, app, child) => Flexible(
                  flex: 3,
                  child: SizedBox(
                    width: (MediaQuery.sizeOf(context).width - 40) * 0.7,
                    height: 50,
                    child: OutlinedButton(
                        onPressed: () async {
                          final token = context.read<UserProvider>().token ?? '';
                          final appId = context.read<ApplicationProvider>().userApplications!.firstWhere((element) {
                            return element.postId == post.id;
                          }).id!;

                          context.read<AppBloc>().add(RequestCancelEvent(token, appId));
                        },
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Theme.of(context).primaryColor),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        child: Text('취소')),
                  ),
                ),
              ),
            ],
          ));
    }
    return SizedBox(
        height: 60,
        width: MediaQuery.sizeOf(context).width - 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Selector<ApplicationProvider, ApplicationEntity>(
              selector: (context, provider) => provider.userApplications!.firstWhere((e) => e.postId == post.id),
              builder: (context, app, child) => Flexible(
                flex: 3,
                child: SizedBox(
                  width: (MediaQuery.sizeOf(context).width - 40) * 0.3,
                  height: 50,
                  child: OutlinedButton(
                      onPressed: () async {
                        final token = context.read<UserProvider>().token ?? '';
                        final appId = context.read<ApplicationProvider>().userApplications!.firstWhere((element) {
                          return element.postId == post.id;
                        }).id!;

                        context.read<AppBloc>().add(RequestCancelEvent(token, appId));
                      },
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Theme.of(context).primaryColor),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      child: Text('취소')),
                ),
              ),
            ),
            const Gap(20),
            Flexible(
              flex: 7,
              child: SizedBox(
                width: (MediaQuery.sizeOf(context).width - 40) * 0.7,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          barrierColor: null,
                          builder: (context) {
                            bool isIos = false;
                            bool isAndroid = false;
                            bool isAndroidDevice = Platform.isAndroid;

                            final prevApp = context.read<ApplicationProvider>().userApplications!.firstWhere((element) {
                              return element.postId == post.id &&
                                  element.applicantId == context.read<UserProvider>().user!.id;
                            });
                            if (prevApp.mobileOs == MobileOsType.ios) {
                              isIos = true;
                              isAndroid = false;
                            }
                            if (prevApp.mobileOs == MobileOsType.android) {
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
                                    SizedBox(
                                        child: Text(' (Device와 동일한 OS만 선택이 가능합니다.)',
                                            style: TextStyle(fontSize: 14, color: Colors.grey))),
                                    const Gap(20),
                                    SizedBox(
                                        child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          child: Row(children: [
                                            Checkbox(
                                                value: isIos,
                                                onChanged: isAndroidDevice
                                                    ? null
                                                    : (value) {
                                                        state(() {
                                                          isIos = value!;
                                                          isAndroid = false;
                                                        });
                                                      }),
                                            Text("IOS",
                                                style: TextStyle(
                                                    fontSize: 16, color: isAndroidDevice ? Colors.grey : Colors.black))
                                          ]),
                                        ),
                                        SizedBox(
                                          child: Row(children: [
                                            Checkbox(
                                                value: isAndroid,
                                                onChanged: isAndroidDevice
                                                    ? (value) {
                                                        state(() {
                                                          isAndroid = value!;
                                                          isIos = false;
                                                        });
                                                      }
                                                    : null),
                                            Text("Android",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: isAndroidDevice ? Colors.black87 : Colors.grey))
                                          ]),
                                        )
                                      ],
                                    )),
                                    const Gap(20),
                                    SizedBox(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (prevApp.mobileOs == MobileOsType.ios && isAndroidDevice == false) {
                                            Get.snackbar('알림', 'OS가 변경 되지 않았습니다.');
                                            return;
                                          }
                                          if (prevApp.mobileOs == MobileOsType.android && isAndroidDevice == true) {
                                            Get.snackbar('알림', 'OS가 변경 되지 않았습니다.');
                                            return;
                                          }
                                          final token = context.read<UserProvider>().token ?? '';
                                          final userId = context.read<UserProvider>().user!.id;
                                          final app = ApplicationEntity(
                                              id: prevApp.id,
                                              platform: prevApp.platform,
                                              mobileOs: isAndroid ? MobileOsType.android : MobileOsType.ios,
                                              status: ApplicationStatus.pending,
                                              postId: post.id,
                                              applicantId: userId);

                                          context.read<AppBloc>().add(RequestUpdateApplicationEvent(token, app));
                                          if (context.mounted) Navigator.pop(context);
                                        },
                                        child: Text("변경하기"),
                                      ),
                                    ),
                                  ])),
                            );
                          });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      '플랫폼 변경',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
            // const Gap(20)
          ],
        ));
  }

  Widget _beforeApplicationSection(BuildContext context, RecruitPostEntity post) {
    return Center(
      child: SizedBox(
        height: 50,
        width: MediaQuery.sizeOf(context).width - 80,
        child: ElevatedButton(
          onPressed: () async {
            final isLogged = context.read<UserProvider>().isLogged ?? false;
            if (!isLogged) {
              showDialog(context: context, builder: (context) => LoginDialog());
              return;
            }

            final token = context.read<UserProvider>().token ?? '';
            final userId = isLogged ? context.read<UserProvider>().user!.id : '';
            final application = context
                .read<ApplicationProvider>()
                .userApplications!
                .firstWhere((e) => e.postId == post.id! && e.applicantId == userId, orElse: () => ApplicationEntity());

            if (post.platform == ApplicationPlatform.web) {
              if (application.id != null && application.status == ApplicationStatus.cancel) {
                final prevApp = application;
                final app = ApplicationEntity(
                    id: prevApp.id,
                    platform: prevApp.platform,
                    mobileOs: null,
                    postId: post.id,
                    status: ApplicationStatus.pending,
                    applicantId: userId);

                context.read<AppBloc>().add(RequestUpdateApplicationEvent(token, app));
              } else {
                final platform = post.platform;
                // context.read<AppBloc>().add(ApplicationDataLoadEvent());
                final app = ApplicationEntity(
                    platform: platform, status: ApplicationStatus.pending, postId: post.id, applicantId: userId);

                context.read<AppBloc>().add(RequestApplyEvent(token, app));
              }
            } else {
              showModalBottomSheet(
                  context: context,
                  barrierColor: null,
                  builder: (context) {
                    bool isIos = false;
                    bool isAndroid = false;
                    bool isAndroidDevice = Platform.isAndroid;
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
                                        value: isAndroidDevice ? false : isIos,
                                        onChanged: isAndroidDevice
                                            ? null
                                            : (value) {
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
                                        value: isAndroidDevice ? isAndroid : false,
                                        onChanged: isAndroidDevice
                                            ? (value) {
                                                state(() {
                                                  isAndroid = value!;
                                                  isIos = false;
                                                });
                                              }
                                            : null),
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
                                        platform: prevApp.platform,
                                        mobileOs: isAndroid ? MobileOsType.android : MobileOsType.ios,
                                        postId: post.id,
                                        status: ApplicationStatus.pending,
                                        applicantId: userId);

                                    context.read<AppBloc>().add(RequestUpdateApplicationEvent(token, app));
                                  } else {
                                    final app = ApplicationEntity(
                                        mobileOs: isAndroid ? MobileOsType.android : MobileOsType.ios,
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
  }

  Widget _rejectedApplicationSection(BuildContext context) {
    return SizedBox(
        height: 50,
        width: MediaQuery.sizeOf(context).width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                  onPressed: null,
                  style:
                      ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: Text("테스터 승인 거부 되었습니다.")),
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
