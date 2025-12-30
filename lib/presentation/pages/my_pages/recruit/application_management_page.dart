import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/domain/entities/application_entity.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';
import 'package:test_us_app/domain/entities/user_review_entity.dart';
import 'package:test_us_app/presentation/bloc/app_bloc/app_event.dart';
import 'package:test_us_app/presentation/provider/application_provider.dart';
import 'package:test_us_app/presentation/provider/post_provider/recruit_post_provider.dart';
import 'package:test_us_app/services/common_height_provider.dart';

import '../../../../data/models/application/application_model.dart';
import '../../../../data/models/user/user_model.dart';
import '../../../../domain/entities/recruit_post_entity.dart';
import '../../../../services/theme_provider.dart';
import '../../../bloc/app_bloc/app_bloc.dart';
import '../../../bloc/app_bloc/app_state.dart';
import '../../../bloc/post_blocs/recruit_post_bloc/recruit_post_bloc.dart';
import '../../../bloc/post_blocs/recruit_post_bloc/recruit_post_event.dart';
import '../../../bloc/post_blocs/recruit_post_bloc/recruit_post_state.dart';
import '../../../bloc/user_bloc/user_bloc.dart';
import '../../../bloc/user_bloc/user_event.dart';
import '../../../bloc/user_bloc/user_state.dart';
import '../../../provider/post_provider/base_post_provider.dart';
import '../../../provider/user_provider.dart';

class ApplicationManagementPage extends StatefulWidget {
  final String? postId;

  const ApplicationManagementPage({super.key, this.postId});

  @override
  State<ApplicationManagementPage> createState() => _ApplicationManagementPageState();
}

class _ApplicationManagementPageState extends State<ApplicationManagementPage> {
  List<GlobalKey<TooltipState>> _toolKeys = [];

  List<ApplicationEntity>? _applications;
  final logger = Logger();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final post = context.read<BasePostProvider>().userRecruitPosts!.firstWhere((e) => e.id == widget.postId);
    // final ids = post.applications!.map((e) => e.applicantId!).toList();

    final token = context.read<UserProvider>().token ?? '';
    context.read<AppBloc>().add(RequestRecruitApplicationsEvent(token, post.applications!));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("신청 관리"),
            ),
            body: BlocConsumer<AppBloc, AppState>(listener: (context, state) {
              // if (state.state == UserDataState.getUsersInfoCompletedState) {
              //   if (_toolKeys.length != state.usersAddAverage!.length) {
              //     setState(() {
              //       _toolKeys = List.generate(state.usersAddAverage!.length, (index) => GlobalKey<TooltipState>());
              //     });
              //   }
              // }
              if (state.state == UserAppState.errorState) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(title: Text('유저 정보를 가져 올 수 없습니다.'), actions: [
                          TextButton(
                              onPressed: () {
                                Get.back();
                                Get.back();
                              },
                              child: Text('확인'))
                        ]));
                return;
              }
            }, builder: (context, state) {
              final hei = GetIt.I.get<ResponsiveHeightProvider>().hei!;
              if (state.state == UserAppState.loadingState) {
                return SizedBox(height: hei, child: Center(child: CircularProgressIndicator()));
              } else if (state is GetRecruitApplicationsState) {
                setState(() {
                  _applications = state.apps;
                });
                return _mainBuilder(state.users);
              }
              return SizedBox(height: hei, child: Center(child: Text('유져 정보를 가져 올 수 없습니다.')));
            })));
  }

  Widget _mainBuilder(List<UserEntity> users) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 20),
            itemBuilder: (context, idx) {
              final application = _applications!.firstWhere((a) => a.applicantId == users[idx].id);
              return Container(
                  // height: 100,
                  width: MediaQuery.sizeOf(context).width - 60,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: isDarkMode
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.grey.withAlpha(84),
                                spreadRadius: 2,
                                blurRadius: 9,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ]),
                  child: Selector<BasePostProvider, RecruitPostEntity>(
                      selector: (context, provider) =>
                          provider.userRecruitPosts!.firstWhere((e) => e.id == widget.postId),
                      builder: (context, post, child) {
                        return Row(
                          children: [
                            Flexible(
                                flex: 7,
                                child: SizedBox(
                                    width: MediaQuery.sizeOf(context).width * 0.7,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // user nickname
                                        SizedBox(
                                          child: Text(
                                            users[idx].nickname!,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              // color: post.applications![idx].status == ApplicationStatus.rejected
                                              //     ? Colors.grey
                                              //     : Colors.black87
                                            ),
                                          ),
                                        ),
                                        const Gap(5),
                                        // email
                                        if (application.status == ApplicationStatus.accepted)
                                          SizedBox(
                                              child: SelectableText(
                                            users[idx].email!,
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                                            enableInteractiveSelection: true,
                                          ))
                                        else if (application.status == ApplicationStatus.rejected)
                                          SizedBox(
                                            child: Text('승인거부 된 유저 입니다.'),
                                          )
                                        else if (application.status == ApplicationStatus.pending)
                                          SizedBox(
                                              child: Text(
                                            '초대 메일주소는 승인 후 표시됩니다.',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                          )),
                                        const Gap(8),
                                        // user type / role
                                        SizedBox(
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.grey.shade400),
                                                    borderRadius: BorderRadius.circular(20)),
                                                child: Center(
                                                  child: Text(
                                                      users[idx].userType == UserType.individuals ? '1인 개발' : '기업/소속',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                        // color: post.applications![idx].status ==
                                                        //         ApplicationStatus.rejected
                                                        //     ? Colors.grey
                                                        //     : Colors.black87
                                                      )),
                                                ),
                                              ),
                                              const Gap(10),
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.grey.shade400),
                                                    borderRadius: BorderRadius.circular(20)),
                                                child: Center(
                                                  child: Text(_getUserRole(users[idx].role!),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                        // color: post.applications![idx].status ==
                                                        //         ApplicationStatus.rejected
                                                        //     ? Colors.grey
                                                        //     : Colors.black87
                                                      )),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Gap(5),
                                        // createdAt
                                        SizedBox(
                                          child: Text(
                                              'update : ${application.updatedAt!.year}년 '
                                              '${application.updatedAt!.month}월 '
                                              '${application.updatedAt!.day}일',
                                              style: TextStyle(
                                                  // color: post.applications![idx].status == ApplicationStatus.rejected
                                                  //     ? Colors.grey
                                                  //     : Colors.black87
                                                  )),
                                        )
                                      ],
                                    ))),
                            Flexible(
                                flex: 3,
                                child: MultiBlocListener(
                                  listeners: [
                                    BlocListener<AppBloc, AppState>(
                                      listener: (context, state) {
                                        if (state.state == UserAppState.applicationCompletedState ||
                                            state.state == UserAppState.applicationRejectCompletedState ||
                                            state.state == UserAppState.applicationUpdateCompletedState) {
                                          setState(() {
                                            for (var e in _applications!) {
                                              if (e.applicantId == state.application!.applicantId) {
                                                e.status = state.application!.status;
                                                e.updatedAt = state.application!.updatedAt;
                                                if (state.application!.platform == ApplicationPlatform.mobile) {
                                                  e.mobileOs = state.application!.mobileOs;
                                                }
                                              }
                                            }
                                          });
                                        }
                                        final token = context.read<UserProvider>().token ?? '';
                                        context
                                            .read<RecruitPostBloc>()
                                            .add(RequestPostDataEvent(token, state.application!.postId!));
                                      },
                                    ),
                                    BlocListener<RecruitPostBloc, RecruitPostState>(
                                        listener: (context, state) {
                                          context.read<BasePostProvider>().updateRecruitPost(state.post!);
                                          context.read<BasePostProvider>().updateUserRecruitPosts(state.post!);
                                        },
                                        listenWhen: (previous, current) =>
                                            current.state == RecruitPostLoadState.getPostByIdCompletedState)
                                  ],
                                  child: Selector<ApplicationProvider, ApplicationEntity>(
                                    selector: (context, provider) {
                                      return provider.userApplications![0];
                                    },
                                    builder: (context, application, child) {
                                      ApplicationStatus appState = application.status!;
                                      // if (application != null) {
                                      // appState = state.applications![idx].status!;
                                      // }
                                      if (appState == ApplicationStatus.accepted) {
                                        return Column(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.sizeOf(context).width * 0.3,
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    final token = context.read<UserProvider>().token ?? '';
                                                    ApplicationEntity app = application;
                                                    app.status = ApplicationStatus.pending;
                                                    app.postId = post.id;
                                                    context
                                                        .read<AppBloc>()
                                                        .add(RequestUpdateApplicationEvent(token, app));
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10))),
                                                  child: Text('승인 취소')),
                                            ),
                                          ],
                                        );
                                      } else if (appState == ApplicationStatus.rejected) {
                                        return SizedBox(
                                          width: MediaQuery.sizeOf(context).width * 0.3,
                                          child: Center(child: Text('승인거부 유져')),
                                        );
                                      }

                                      return SizedBox(
                                          width: MediaQuery.sizeOf(context).width * 0.3,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.sizeOf(context).width * 0.3,
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      final token = context.read<UserProvider>().token ?? '';
                                                      // TODO: 신청자 승인/거부 로직 확인 필요함.
                                                      context.read<AppBloc>().add(RequestCompleteApplicationEvent(
                                                          token, application.applicantId!, widget.postId!));
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10))),
                                                    child: Text('승인')),
                                              ),
                                              const Gap(4),
                                              SizedBox(
                                                width: MediaQuery.sizeOf(context).width * 0.3,
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      _userRejectDialog(context, application);
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10))),
                                                    child: Text('거부')),
                                              ),
                                            ],
                                          ));
                                    },
                                  ),
                                ))
                          ],
                        );
                      }));
            },
            separatorBuilder: (context, idx) => const Gap(10),
            itemCount: users.length));
  }

  Future<void> _userRejectDialog(BuildContext context, ApplicationEntity app) async {
    await showDialog(
        context: context,
        builder: (context) => Dialog(
                child: Container(
              height: 200,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: (200 - 40) * 0.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('테스터 신청을 거부하시겠습니까?'), Text('신청 거부 시 신청 상태를 다시 변경 할 수 없습니다.')],
                    ),
                  ),
                  SizedBox(
                    height: (200 - 40) * 0.3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text('취소')),
                        ),
                        const Gap(10),
                        SizedBox(
                          child: ElevatedButton(
                              onPressed: () {
                                final token = context.read<UserProvider>().token ?? '';
                                context
                                    .read<AppBloc>()
                                    .add(RequestRejectApplicationEvent(token, app.applicantId!, app.postId!));
                                Get.back();
                              },
                              child: Text('거부')),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )));
  }

  String _getUserRole(UserRole role) {
    switch (role) {
      case UserRole.programmer:
        return '프로그래머';
      case UserRole.designer:
        return '디자이너';
      case UserRole.marketer:
        return '마케터';
      case UserRole.manager:
        return '매니저';
      case UserRole.operator:
        return '운영자';
      case UserRole.planner:
        return '기획자';
      case UserRole.analyst:
        return '데이터 분석';
      case UserRole.pm:
        return '프로젝트 메니져';
      case UserRole.publisher:
        return '퍼블리셔';
      case UserRole.qa:
        return 'QA';
      case UserRole.cs:
        return 'CS';
      case UserRole.user:
        return '유져';
    }
  }

// String _getState(ApplicationStatus status) {
//   switch (status) {
//     case ApplicationStatus.pending:
//       return '대기 중';
//     case ApplicationStatus.accepted:
//       return '승인';
//     case ApplicationStatus.rejected:
//       return '거부';
//     default:
//       return '';
//   }
// }
}
