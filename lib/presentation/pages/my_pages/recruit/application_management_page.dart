import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:test_us_app/data/models/package/recruit_post_applications_model.dart';
import 'package:test_us_app/presentation/bloc/app_bloc/app_event.dart';
import 'package:test_us_app/services/common_height_provider.dart';

import '../../../../data/models/application/application_model.dart';
import '../../../../data/models/user/user_model.dart';
import '../../../../services/theme_provider.dart';
import '../../../bloc/app_bloc/app_bloc.dart';
import '../../../bloc/app_bloc/app_state.dart';
import '../../../bloc/post_blocs/recruit_post_bloc/recruit_post_bloc.dart';
import '../../../bloc/post_blocs/recruit_post_bloc/recruit_post_event.dart';
import '../../../bloc/post_blocs/recruit_post_bloc/recruit_post_state.dart';
import '../../../provider/user_provider.dart';

class ApplicationManagementPage extends StatefulWidget {
  final String? postId;

  const ApplicationManagementPage({super.key, this.postId});

  @override
  State<ApplicationManagementPage> createState() => _ApplicationManagementPageState();
}

class _ApplicationManagementPageState extends State<ApplicationManagementPage> {
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    final token = context.read<UserProvider>().token ?? '';
    context.read<RecruitPostBloc>().add(RequestPostApplicationsInfoEvent(token, widget.postId!));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("신청 관리"),
            ),
            body: BlocConsumer<RecruitPostBloc, RecruitPostState>(
                listener: (context, state) {},
                builder: (context, state) {
                  final hei = GetIt.I.get<ResponsiveHeightProvider>().hei!;
                  if (state.state == RecruitPostLoadState.dataLoadState) {
                    return SizedBox(height: hei, child: Center(child: CircularProgressIndicator()));
                  } else if (state is GetPostApplicationsInfoState) {
                    return _mainBuilder(state.info!);
                  }
                  return SizedBox(height: hei, child: Center(child: Text('유져 정보를 가져 올 수 없습니다.')));
                })));
  }

  Widget _mainBuilder(List<TResRecruitPostApplicationsInfo> info) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state.state == UserAppState.applicationCompletedState) {
        } else if (state.state == UserAppState.applicationUpdateCompletedState) {
        } else if (state.state == UserAppState.applicationRejectCompletedState) {}
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 20),
              itemBuilder: (context, idx) {
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // user info
                        _userInfoSection(context, info[idx]),
                        const Gap(20),
                        // buttons
                        _buttonSection(context, info[idx])
                      ],
                    ));
              },
              separatorBuilder: (context, idx) => const Gap(20),
              itemCount: info.length)),
    );
  }

  Widget _userInfoSection(BuildContext context, TResRecruitPostApplicationsInfo info) {
    return SizedBox(
        width: MediaQuery.sizeOf(context).width - 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
                height: 50,
                width: 50,
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: info.user!.profileImg == null || info.user!.profileImg!.url == null
                      ? const AssetImage('assets/images/Generic avatar.png')
                      : NetworkImage(info.user!.profileImg!.url!),
                )),
            const Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Text(
                          info.user!.nickname!,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            // color: post.applications![idx].status == ApplicationStatus.rejected
                            //     ? Colors.grey
                            //     : Colors.black87
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Text(
                            '${info.application!.updatedAt!.year}년 '
                            '${info.application!.updatedAt!.month}월 '
                            '${info.application!.updatedAt!.day}일',
                            style: TextStyle(
                                // color: post.applications![idx].status == ApplicationStatus.rejected
                                //     ? Colors.grey
                                //     : Colors.black87
                                )),
                      )
                    ],
                  ),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: Text(
                                    info.user!.userType == UserType.individuals
                                        ? '1인 개발'
                                        : (info.user!.userType == UserType.normal ? "일반 유져" : '기업/소속'),
                                    style: TextStyle(
                                      fontSize: 12,
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
                                child: Text(_getUserRole(info.user!.role!),
                                    style: TextStyle(
                                      fontSize: 12,
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
                        SizedBox(
                          height: 30,
                          width: 100,
                          child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: Text("테스터 정보")),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buttonSection(BuildContext context, TResRecruitPostApplicationsInfo info) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {
        if (state.state == UserAppState.applicationCompletedState ||
            state.state == UserAppState.applicationUpdateCompletedState ||
            state.state == UserAppState.applicationRejectCompletedState) {
          if (state.application != null) {
            info.application!.status = state.application!.status;
          }
        }
      },
      //note: 리스트의 버튼이 동시에 변겯되는 것을 방지. 이 기능은 테스트 필요.
      buildWhen: (previous, current) {
        if (current.application != null && current.application!.id == info.application!.id) {
          return true;
        }
        if (current.state == UserAppState.loadingState) {
          return true;
        }

        return false;
      },
      builder: (context, state) {
        if (state.state == UserAppState.loadingState) {
          return _buildShimmerButtons(context);
        }

        switch (info.application!.status) {
          case ApplicationStatus.accepted:
            return _buildButtons(
              context,
              leftText: "승인 취소",
              onLeftTap: () => _userRejectDialog(context, info),
              rightText: "메시지 보내기",
              onRightTap: () {},
            );
          case ApplicationStatus.rejected:
            return Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text('미선정 된 테스터 입니다.')),
            );
          default:
            return _buildButtons(
              context,
              leftText: "미선정",
              onLeftTap: () => _userRejectDialog(context, info),
              rightText: "승인",
              onRightTap: () {
                final token = context.read<UserProvider>().token ?? '';
                context
                    .read<AppBloc>()
                    .add(RequestCompleteApplicationEvent(token, info.user!.userId!, info.application!.postId!));
              },
            );
        }
      },
    );
  }

  Widget _buildButtons(BuildContext context,
      {required String leftText,
      required VoidCallback onLeftTap,
      required String rightText,
      required VoidCallback onRightTap}) {
    final width = MediaQuery.sizeOf(context).width - 60;
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 3,
            child: SizedBox(
              height: 40,
              width: width * 0.3,
              child: OutlinedButton(
                  onPressed: onLeftTap,
                  style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      side: BorderSide(color: Theme.of(context).colorScheme.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: Text(leftText)),
            ),
          ),
          const Gap(10),
          Flexible(
            flex: 7,
            child: SizedBox(
              height: 40,
              width: width * 0.7,
              child: ElevatedButton(
                  onPressed: onRightTap,
                  style:
                      ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: Text(rightText)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildShimmerButtons(BuildContext context) {
    return SizedBox(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: _buildButtons(context, leftText: "", onLeftTap: () {}, rightText: "", onRightTap: () {}),
      ),
    );
  }

  Future<void> _userRejectDialog(BuildContext context, TResRecruitPostApplicationsInfo info) async {
    await showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Container(
                height: 200,
                padding: EdgeInsets.all(20),
                child: LayoutBuilder(
                  builder: (context, constraints) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: constraints.maxHeight * 0.7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('테스터를 미선정 하시나요?'), Text('미선정된 테스터는 다시 신청 할 수 없습니다.')],
                        ),
                      ),
                      SizedBox(
                        height: constraints.maxHeight * 0.3,
                        width: constraints.maxWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 3,
                              child: SizedBox(
                                width: constraints.maxWidth * 0.3,
                                child: OutlinedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Theme.of(context).colorScheme.primary),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    child: Text('취소')),
                              ),
                            ),
                            const Gap(10),
                            Flexible(
                              flex: 7,
                              child: SizedBox(
                                width: constraints.maxWidth * 0.7,
                                child: ElevatedButton(
                                    onPressed: () {
                                      final token = context.read<UserProvider>().token ?? '';
                                      context.read<AppBloc>().add(RequestRejectApplicationEvent(
                                          token, info.user!.userId!, info.application!.postId!));
                                      Get.back();
                                    },
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    child: Text('확인(미선정)')),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
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
