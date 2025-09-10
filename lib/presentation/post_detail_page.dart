import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/data/models/application/application_model.dart';
import 'package:test_us_app/domain/entities/application_entity.dart';
import 'package:test_us_app/presentation/bloc/app_bloc/app_event.dart';
import 'package:test_us_app/presentation/bloc/app_bloc/app_state.dart';
import 'package:test_us_app/presentation/post_create_page.dart';
import 'package:test_us_app/presentation/provider/application_provider.dart';
import 'package:test_us_app/presentation/provider/post_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/services/common_height_provider.dart';

import '../domain/entities/post_entity.dart';
import '../domain/entities/user_entity.dart';
import 'bloc/app_bloc/app_bloc.dart';
import 'bloc/data_bloc/data_bloc.dart';
import 'bloc/data_bloc/data_event.dart';
import 'bloc/data_bloc/data_state.dart';

class PostDetailPage extends StatefulWidget {
  final PostEntity? post;

  const PostDetailPage({super.key, this.post});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final logger = Logger();
  late PostEntity? _post;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.post != null) _post = widget.post!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataBloc, DataState>(builder: (context, state) {
      if (state.state == DataLoadState.postUpdateCompletedState) {
        _post = context.read<PostProvider>().posts!.firstWhere((element) {
          return element.id == _post!.id;
        });
        context.read<DataBloc>().add(RequestCompleteEvent());
      } else if (state.state == DataLoadState.getPostByIdCompletedState) {
        _post = state.post;
        context.read<DataBloc>().add(RequestCompleteEvent());
      } else if (state.state == DataLoadState.errorState) {
        Get.snackbar("에러", "알 수 없는 문제로 수정 실패 했습니다.");
      }
      final hei = GetIt.instance.get<ResponsiveHeightProvider>().hei!;
      return SafeArea(
          child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              // bottom: PreferredSize(
              //   preferredSize: Size.fromHeight(100),
              //   child: Container(
              //     child: Text(";alskdjflaksdjlaksdf"),
              //   )
              // ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios_new),
              ),
              actions: [
                _post != null && widget.post!.author!.id == context.read<UserProvider>().user!.id
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
                            Get.to(PostCreatePage(post: _post));
                          } else if (value == 2) {
                            Get.defaultDialog(title: "삭제", middleText: "삭제하시겠습니까?", actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text("취소"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  final token = context.read<UserProvider>().token ?? "";
                                  try {
                                    context.read<DataBloc>().add(RequestPostDeleteEvent(context, token, _post!.id!));
                                    Get.back();
                                  } on Exception catch (e) {
                                    // TODO
                                    Get.snackbar('알림', '삭제 실패');
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
              expandedHeight: hei * 0.3,
              // pinned: true,
            ),
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
                      _post!.title!,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    )),
                    const Gap(10),
                    SizedBox(
                        child: Text(_post!.subtitle!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                    const Gap(10),
                    SizedBox(
                      child: Row(
                        children: [
                          SizedBox(
                              child: Text(
                            '${_post!.author!.nickname}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          )),
                          const Gap(10),
                          SizedBox(
                            child: _post!.platform!.length == 1
                                ? Text(_post!.platform![0])
                                : Row(
                                    children: [Text(_post!.platform![0]), const Gap(10), Text(_post!.platform![1])],
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
                        minHeight: hei * 0.4,
                      ),
                      child: SizedBox(
                          // height: constraints.maxHeight * 0.5,
                          child: Text(widget.post!.contents!)),
                    ),
                    const Gap(40),
                    if (_post != null && _post!.author!.id != context.read<UserProvider>().user!.id)
                      _applicationSection()
                  ],
                ),
              ),
            )
          ],
        ),
      ));
    });
  }

  Widget _applicationSection() {
    final isApply = context.read<ApplicationProvider>().applications!.any((element) {
      return element.postId == _post!.id;
    });
    if (isApply) {
      final app = context.read<ApplicationProvider>().applications!.firstWhere((element) {
        return element.postId == _post!.id;
      });
      if (app.status == ApplicationStatus.pending || app.status == ApplicationStatus.accepted) {
        return _afterApplicationSection();
      } else if (app.status == ApplicationStatus.rejected) {
        return _rejectedApplicationSection();
      } else {
        return _beforeApplicationSection(app.status);
      }
    } else {
      return _afterApplicationSection();
    }
  }

  Widget _afterApplicationSection() {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      if (state.state == UserAppState.requestCompletedState) {
        context.read<DataBloc>().add(ReloadPostEvent());
        context.read<AppBloc>().add(RequestCompletedEvent());
      }
      return SizedBox(
          height: 180,
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Selector<ApplicationProvider, ApplicationEntity>(
                selector: (context, provider) => provider.applications!.firstWhere((e) => e.postId == _post!.id),
                builder: (context, app, child) => SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        final token = context.read<UserProvider>().token ?? '';
                        final appId = context.read<ApplicationProvider>().applications!.firstWhere((element) {
                          return element.postId == _post!.id;
                        }).id!;
                        context.read<AppBloc>().add(RequestApplyCancelEvent(context, token, appId));
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      child: Text('신청 취소 ${app.status == ApplicationStatus.pending ? '(대기 중)' : '(테스트 중)'}')),
                ),
              ),
              const Gap(20),
              if (_post!.platform!.contains('IOS') || _post!.platform!.contains('ANDROID'))
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

                              final prevApp =
                              context.read<ApplicationProvider>().applications!.firstWhere((element) {
                                return element.postId == _post!.id;
                              });
                              if(prevApp.platform == ApplicationPlatform.ios) isIos = true;
                              if(prevApp.platform == ApplicationPlatform.android) isAndroid = true;

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
                                                postId: _post!.id,
                                                applicantId: userId);
                                            context.read<AppBloc>().add(RequestApplyUpdate(context, token, app));
                                            Navigator.pop(context);
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

  Widget _beforeApplicationSection(ApplicationStatus? status) {
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      if (state.state == UserAppState.requestCompletedState) {
        context.read<DataBloc>().add(ReloadPostEvent());
        context.read<AppBloc>().add(RequestCompletedEvent());
      }
      return Center(
        child: SizedBox(
          height: 50,
          width: MediaQuery.sizeOf(context).width - 80,
          child: ElevatedButton(
            onPressed: () async {
              final token = context.read<UserProvider>().token ?? '';
              final userId = context.read<UserProvider>().user!.id;

              if (_post!.platform!.contains('WEB')) {
                final app = ApplicationEntity(
                    platform: ApplicationPlatform.web,
                    status: ApplicationStatus.pending,
                    postId: _post!.id,
                    applicantId: userId);
                context.read<AppBloc>().add(RequestApplyEvent(context, token, app));
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
                                    if (status == ApplicationStatus.cancel) {
                                      final prevApp =
                                          context.read<ApplicationProvider>().applications!.firstWhere((element) {
                                        return element.postId == _post!.id;
                                      });
                                      final app = ApplicationEntity(
                                          id: prevApp.id,
                                          platform: isAndroid ? ApplicationPlatform.android : ApplicationPlatform.ios,
                                          status: ApplicationStatus.pending,
                                          postId: _post!.id,
                                          applicantId: userId);
                                      context.read<AppBloc>().add(RequestApplyUpdate(context, token, app));
                                    } else {
                                      final app = ApplicationEntity(
                                          platform: isAndroid ? ApplicationPlatform.android : ApplicationPlatform.ios,
                                          status: ApplicationStatus.pending,
                                          postId: _post!.id,
                                          applicantId: userId);
                                      context.read<AppBloc>().add(RequestApplyEvent(context, token, app));
                                    }
                                    Navigator.pop(context);
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
}
