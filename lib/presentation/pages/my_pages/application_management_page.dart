import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:test_us_app/domain/entities/application_entity.dart';
import 'package:test_us_app/presentation/bloc/app_bloc/app_event.dart';
import 'package:test_us_app/presentation/provider/post_provider/recruit_post_provider.dart';
import 'package:test_us_app/services/common_height_provider.dart';

import '../../../data/models/application/application_model.dart';
import '../../../data/models/user/user_model.dart';
import '../../../domain/entities/recruit_post_entity.dart';
import '../../bloc/app_bloc/app_bloc.dart';
import '../../bloc/app_bloc/app_state.dart';
import '../../bloc/user_bloc/user_bloc.dart';
import '../../bloc/user_bloc/user_event.dart';
import '../../bloc/user_bloc/user_state.dart';
import '../../provider/user_provider.dart';

class ApplicationManagementPage extends StatefulWidget {
  final String? postId;

  const ApplicationManagementPage({super.key, this.postId});

  @override
  State<ApplicationManagementPage> createState() => _ApplicationManagementPageState();
}

class _ApplicationManagementPageState extends State<ApplicationManagementPage> {
  List<GlobalKey<TooltipState>> _toolKeys = [];
  late List<ApplicationEntity> _applications;
  final logger = Logger();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _applications =
        context.read<RecruitPostProvider>().recruitmentPosts!.firstWhere((element) => element.id == widget.postId).applications!;

    final applicantIds = _applications.map((app) => app.applicantId!).toList();
    final token = context.read<UserProvider>().token ?? '';
    context.read<UserBloc>().add(RequestUsersDataEvent(token, applicantIds));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("신청 관리"),
            ),
            body: BlocConsumer<UserBloc, UserState>(listener: (context, state) {
              if (state.state == UserDataState.getUsersInfoCompletedState) {
                if (_toolKeys.length != state.usersAddAverage!.length) {
                  setState(() {
                    _toolKeys = List.generate(state.usersAddAverage!.length, (index) => GlobalKey<TooltipState>());
                  });
                }
              }
            }, builder: (context, state) {
              final hei = GetIt.I.get<ResponsiveHeightProvider>().hei!;
              if (state.state == UserDataState.loadingState) {
                return SizedBox(height: hei, child: Center(child: CircularProgressIndicator()));
              }
              if (state.usersAddAverage != null) {
                return _mainBuilder(state.usersAddAverage!);
              }
              return SizedBox(height: hei, child: Center(child: CircularProgressIndicator()));
            })));
  }

  // Future<void> _applicationInfo(BuildContext context, ApplicationEntity application, UserEntity user) async {
  //   await showDialog(
  //       context: context,
  //       builder: (context) {
  //         return BlocConsumer<ReviewBloc, ReviewState>(listener: (context, state) {
  //           if (state.state == ReviewDataState.getReviewAverageCompletedState) {}
  //         }, builder: (context, state) {
  //           if (state.state == ReviewDataState.loadingState) {
  //             return SizedBox(
  //                 height: MediaQuery.sizeOf(context).height * 0.5, child: Center(child: CircularProgressIndicator()));
  //           }
  //           final average = state.reviews == null || state.reviews!.isEmpty
  //               ? 0.toDouble()
  //               : (state.reviews!.map((e) => e.rating).reduce((value, element) => value! + element!)! /
  //                       state.reviews!.length)
  //                   .toStringAsFixed(2);
  //           final length = state.reviews == null || state.reviews!.isEmpty ? 0 : state.reviews!.length;
  //           return Dialog(
  //             insetPadding: EdgeInsets.symmetric(horizontal: 20),
  //             child: LayoutBuilder(
  //               builder: (context, constraints) => Container(
  //                 width: MediaQuery.sizeOf(context).width > 600 ? 500 : constraints.maxWidth * 0.9,
  //                 height: constraints.maxHeight * 0.5,
  //                 padding: EdgeInsets.all(20.0),
  //                 child: Column(
  //                   children: [
  //                     Flexible(
  //                       flex: 8,
  //                       child: SizedBox(
  //                         height: (constraints.maxHeight * 0.5) * 0.8,
  //                         child: Column(
  //                           children: [
  //                             // close button(hei: 1)
  //                             SizedBox(
  //                                 height: (constraints.maxHeight * 0.5) * 0.1,
  //                                 child: Row(
  //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                   crossAxisAlignment: CrossAxisAlignment.center,
  //                                   children: [
  //                                     SizedBox(
  //                                       child:
  //                                           Text('신청 정보', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
  //                                     ),
  //                                     SizedBox(
  //                                       child: TextButton(
  //                                           onPressed: () {
  //                                             Get.back();
  //                                           },
  //                                           child: Text(
  //                                             '닫기',
  //                                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  //                                           )),
  //                                     )
  //                                   ],
  //                                 )),
  //                             const Gap(10),
  //                             // rate average(hei: 2.5)
  //                             Container(
  //                               height: (constraints.maxHeight * 0.5) * 0.25,
  //                               decoration: BoxDecoration(
  //                                   border: Border.all(
  //                                     color: Colors.grey.withAlpha(84),
  //                                   ),
  //                                   borderRadius: BorderRadius.circular(10),
  //                                   color: Colors.grey.shade300,
  //                                   boxShadow: [
  //                                     BoxShadow(
  //                                       color: Colors.grey.withAlpha(84),
  //                                       spreadRadius: 10,
  //                                       blurRadius: 20,
  //                                       offset: Offset(0, 3), // changes position of shadow
  //                                     ),
  //                                   ]),
  //                               child: Row(
  //                                 crossAxisAlignment: CrossAxisAlignment.center,
  //                                 children: [
  //                                   Flexible(
  //                                     flex: 5,
  //                                     child: SizedBox(
  //                                       width: ((constraints.maxWidth * 0.9) - 40) / 2,
  //                                       child: Column(
  //                                         mainAxisAlignment: MainAxisAlignment.center,
  //                                         crossAxisAlignment: CrossAxisAlignment.center,
  //                                         children: [
  //                                           Text('테스터 평점'),
  //                                           Text(
  //                                             '$average',
  //                                             style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   SizedBox(
  //                                       height: (constraints.maxHeight * 0.5) * 0.18,
  //                                       child: VerticalDivider(
  //                                         width: 1,
  //                                         color: Colors.grey.withAlpha(48),
  //                                       )),
  //                                   Flexible(
  //                                     flex: 5,
  //                                     child: SizedBox(
  //                                       width: ((constraints.maxWidth * 0.9) - 40) / 2,
  //                                       child: Column(
  //                                         mainAxisAlignment: MainAxisAlignment.center,
  //                                         crossAxisAlignment: CrossAxisAlignment.center,
  //                                         children: [
  //                                           Text('테스트 서비스 수'),
  //                                           Text(
  //                                             '$length',
  //                                             style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                             const Gap(10),
  //                             // user info(hei: 3)
  //                             SizedBox(
  //                                 height: (constraints.maxHeight * 0.5) * 0.3,
  //                                 child: Column(
  //                                   children: [
  //                                     Text(user.nickname!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
  //                                     Text(user.userType == UserType.individuals ? '1인 개발' : '기업 / 소속',
  //                                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
  //                                     Text(_getUserRole(user.role!),
  //                                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
  //                                   ],
  //                                 ))
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                     Flexible(
  //                       flex: 2,
  //                       child: BlocListener<AppBloc, AppState>(
  //                         listener: (context, state){
  //
  //                         },
  //                         child: Container(
  //                             height: (constraints.maxHeight * 0.5) * 0.2,
  //                             padding: EdgeInsets.only(top: 20),
  //                             child: Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               crossAxisAlignment: CrossAxisAlignment.center,
  //                               children: [
  //                                 SizedBox(
  //                                   height: 40,
  //                                   width: 100,
  //                                   child: ElevatedButton(
  //                                       onPressed: () {
  //                                         final token = context.read<UserProvider>().token ?? '';
  //                                         context.read<AppBloc>().add(RequestRejectApplicationEvent(token, user.id!, application.postId!));
  //                                       },
  //                                       style: ElevatedButton.styleFrom(
  //                                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
  //                                       child: Text('거부')),
  //                                 ),
  //                                 const Gap(20),
  //                                 SizedBox(
  //                                   height: 40,
  //                                   width: 100,
  //                                   child: ElevatedButton(
  //                                       onPressed: () {},
  //                                       style: ElevatedButton.styleFrom(
  //                                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
  //                                       child: Text('승인')),
  //                                 )
  //                               ],
  //                             )),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           );
  //         });
  //       });
  // }

  Widget _mainBuilder(List<Map<String, dynamic>> users) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 20),
            itemBuilder: (context, idx) {
              return Container(
                  // height: 100,
                  width: MediaQuery.sizeOf(context).width - 60,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(84),
                          spreadRadius: 2,
                          blurRadius: 9,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: Row(
                    children: [
                      Flexible(
                          flex: 7,
                          child: BlocSelector<AppBloc, AppState, RecruitPostEntity?>(
                              selector: (state) => state.newPost,
                              builder: (context, post) {
                                // ApplicationStatus appState = _applications[idx].status!;
                                // if (post != null && post.id == _applications[idx].postId) {
                                //   appState = post.applications![idx].status!;
                                // }
                                DateTime appDate = _applications[idx].updatedAt!;
                                if (post != null && post.id == _applications[idx].postId) {
                                  appDate = post.applications![idx].updatedAt!;
                                }
                                return SizedBox(
                                    width: MediaQuery.sizeOf(context).width * 0.7,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // user nickname
                                        SizedBox(
                                          child: Text(
                                            "${users[idx]['user'].nickname!}",
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        const Gap(5),
                                        // email
                                        if (post != null &&
                                            post.applications![idx].status == ApplicationStatus.accepted)
                                          SizedBox(
                                              child: GestureDetector(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(text: users[idx]['user'].email));
                                              Get.snackbar(
                                                '알림',
                                                '이메일이 클립보드에 복사되었습니다.',
                                                snackPosition: SnackPosition.BOTTOM,
                                                backgroundColor: Colors.grey.shade300,
                                                colorText: Colors.black
                                              );
                                              return;
                                            },
                                            child: Text(
                                              users[idx]['user'].email!,
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                                            ),
                                          ))
                                        else
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
                                                      users[idx]['user'].userType == UserType.individuals
                                                          ? '1인 개발'
                                                          : '기업/소속',
                                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                                ),
                                              ),
                                              const Gap(10),
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.grey.shade400),
                                                    borderRadius: BorderRadius.circular(20)),
                                                child: Center(
                                                  child: Text(_getUserRole(users[idx]['user'].role!),
                                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                                ),
                                              ),
                                              const Gap(10),
                                              // rating / review count
                                              // 데이터를 어떤식으로 받아오고 처리해야 하는지 확인해야함. 데이터가 없을 때는 어떻게 처리할지 확인해야함.
                                              // selector을 사용하는게 맞는지 ... 다시 고민해보자..
                                              GestureDetector(
                                                onTap: () {
                                                  _toolKeys[idx].currentState!.ensureTooltipVisible();
                                                },
                                                child: Tooltip(
                                                  key: _toolKeys.isEmpty ? null : _toolKeys[idx],
                                                  message: "완료한 테스터 수 : ${users[idx]['reviewCount']}",
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.grey.shade400),
                                                        borderRadius: BorderRadius.circular(20)),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          child: Icon(Symbols.star,
                                                              fill: 1, size: 16, color: Colors.yellow),
                                                        ),
                                                        const Gap(5),
                                                        SizedBox(
                                                          child: Text(
                                                            '${users[idx]['average']}',
                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const Gap(5),
                                        // createdAt
                                        SizedBox(
                                            child: Text('update : ${appDate.year}년 '
                                                '${appDate.month}월 '
                                                '${appDate.day}일')),
                                      ],
                                    ));
                              })),
                      Flexible(
                          flex: 3,
                          child: BlocConsumer<AppBloc, AppState>(
                            listener: (context, state) {
                              if (state.state == UserAppState.applicationCompletedState) {
                                context.read<RecruitPostProvider>().updatePost(state.newPost!);
                              }else if(state.state == UserAppState.applicationRejectCompletedState){
                                context.read<RecruitPostProvider>().updatePost(state.newPost!);
                                // Get.back();
                              }
                            },
                            builder: (context, state) {
                              ApplicationStatus appState = _applications[idx].status!;
                              if (state.newPost != null) {
                                appState = state.newPost!.applications![idx].status!;
                              }
                              if (appState == ApplicationStatus.accepted) {
                                return SizedBox(
                                  width: MediaQuery.sizeOf(context).width * 0.3,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        final token = context.read<UserProvider>().token ?? '';
                                        final application = ApplicationEntity(
                                          postId: _applications[idx].postId,
                                          applicantId: _applications[idx].applicantId,
                                          status: ApplicationStatus.accepted,
                                        );
                                        context.read<AppBloc>().add(RequestRejectApplicationEvent(
                                            token, application.applicantId!, application.postId!));
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                      child: Text('승인 취소')),
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
                                        child: ElevatedButton(
                                            onPressed: () {
                                              final token = context.read<UserProvider>().token ?? '';
                                              // TODO: 신청자 승인/거부 로직 확인 필요함.
                                              context.read<AppBloc>().add(RequestCompleteApplicationEvent(
                                                  token, _applications[idx].applicantId!, _applications[idx].postId!));
                                            },
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                            child: Text('승인')),
                                      ),
                                      const Gap(4),
                                      SizedBox(
                                        child: ElevatedButton(
                                            onPressed: () {
                                              _userRejectDialog(context, _applications[idx]);
                                            },
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                            child: Text('거부')),
                                      ),
                                    ],
                                  ));
                            },
                          ))
                    ],
                  ));
            },
            separatorBuilder: (context, idx) => const Gap(10),
            itemCount: users.length));
  }

  Future<void> _userRejectDialog(BuildContext context, ApplicationEntity app) async {
    await showDialog(context: context, builder: (context) => Dialog(
      child: Container(
        height: 200,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: (200-40) * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('테스터 신청을 거부하시겠습니까?'),
                  Text('신청 거부 시 신청 상태를 다시 변경 할 수 없습니다.')
                ],
              ),
            ),
            SizedBox(
              height: (200-40) * 0.3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: ElevatedButton(onPressed: (){
                      Get.back();
                    }, child: Text('취소')),
                  ),
                  const Gap(10),
                  SizedBox(
                    child: ElevatedButton(onPressed: (){
                      final token = context.read<UserProvider>().token ?? '';
                      context.read<AppBloc>().add(RequestRejectApplicationEvent(
                          token, app.applicantId!, app.postId!));
                      Get.back();
                    }, child: Text('거부')),
                  )
                ],
              ),
            )
          ],
        ),
      )
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
