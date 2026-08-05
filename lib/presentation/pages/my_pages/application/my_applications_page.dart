import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/data/models/application/application_model.dart';
import 'package:test_us_app/domain/entities/application_entity.dart';
import 'package:test_us_app/presentation/bloc/app_bloc/app_event.dart';
import 'package:test_us_app/presentation/bloc/app_bloc/app_state.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/recruit_post_bloc/recruit_post_bloc.dart';
import 'package:test_us_app/presentation/components/alerts/two_button_confirm_alert.dart';
import 'package:test_us_app/presentation/components/buttons/custom_outline_button.dart';
import 'package:test_us_app/presentation/pages/post/promotion_post_pages/promotion_post_detail_page.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:test_us_app/utils/time_util.dart';
import 'package:test_us_app/utils/type_conversion_util.dart';

import '../../../../data/models/post/recruit_post_model.dart';
import '../../../../domain/entities/recruit_post_entity.dart';
import '../../../../services/theme_provider.dart';
import '../../../bloc/app_bloc/app_bloc.dart';
import '../../../bloc/post_blocs/recruit_post_bloc/recruit_post_event.dart';
import '../../../bloc/post_blocs/recruit_post_bloc/recruit_post_state.dart';
import '../../../provider/application_provider.dart';
import '../../post/tester_post_pages/recruit_post_detail_page.dart';

class MyApplicationsPage extends StatefulWidget {
  const MyApplicationsPage({super.key});

  @override
  State<MyApplicationsPage> createState() => _MyApplicationsPageState();
}

class _MyApplicationsPageState extends State<MyApplicationsPage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.read<ThemeProvider>().isDarkMode;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('나의 테스터 신청'),
      ),
      body: BlocListener<AppBloc, AppState>(
        listener: (context, state) {
          final appProvider = context.read<ApplicationProvider>();
          if (state.state == UserAppState.applicationCancelCompletedState) {
            appProvider.cancelApplication(state.application!);
          } else if (state.state == UserAppState.applicationUpdateCompletedState) {}
        },
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Selector<ApplicationProvider, List<ApplicationEntity>>(
              selector: (context, provider) {
                // todo: createdAt 내림차순
                return provider.userApplications ?? [];
              },
              builder: (context, applications, child) {
                final hei = GetIt.I.get<ResponsiveHeightProvider>().hei ?? 0;
                return applications.isEmpty
                    ? SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        height: hei,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('아직 테스터 신청 내용이 없어요.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                            const Gap(10),
                            Text('흥미있는 프로젝트를 테스트해보고'),
                            Text('인사이트를 얻어 보세오.'),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemBuilder: (context, idx) {
                          final posts = applications.map((e) => e.postInfo!).toList();
                          return GestureDetector(
                            onTap: () {
                              if (posts[idx].isExpired!) {
                                Get.snackbar('알림', '종료(만료) 또는 삭제된 프로덕트 입니다.');
                                return;
                              }
                              Get.to(() => RecruitPostDetailPage(postId: posts[idx].postId!));
                            },
                            child: Container(
                              height: 120,
                              width: MediaQuery.sizeOf(context).width,
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                              child: LayoutBuilder(
                                builder: (context, constraints) => Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                        flex: 3,
                                        child: SizedBox(
                                            width: constraints.maxWidth * 0.3,
                                            // height: 150,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                imageUrl: posts[idx].thumbnailUrl!,
                                                fit: BoxFit.cover,
                                                color: posts[idx].isExpired! ? Colors.grey.shade200 : null,
                                                colorBlendMode: posts[idx].isExpired! ? BlendMode.saturation : null,
                                              ),
                                            ))),
                                    Flexible(
                                      flex: 7,
                                      child: Container(
                                        // height: 150,
                                        width: constraints.maxWidth * 0.7,
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Flexible(
                                                    flex: 7,
                                                    child: SizedBox(
                                                      width: (constraints.maxWidth * 0.7) * 0.7,
                                                      child: Text(
                                                        posts[idx].title!,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold,
                                                            overflow: TextOverflow.ellipsis),
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 2,
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                                      decoration: BoxDecoration(
                                                        color: applications[idx].status == ApplicationStatus.pending
                                                            ? Colors.blue.shade600
                                                            : applications[idx].status == ApplicationStatus.rejected
                                                                ? Colors.black87
                                                                : applications[idx].status == ApplicationStatus.cancel
                                                                    ? Colors.red.shade300
                                                                    : Theme.of(context).colorScheme.primary,
                                                        border: Border.all(color: Colors.grey),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      width: (constraints.maxWidth * 0.7) * 0.2,
                                                      child: Text(
                                                        applications[idx].status == ApplicationStatus.pending
                                                            ? '대기중'
                                                            : applications[idx].status == ApplicationStatus.rejected
                                                                ? '거부됨'
                                                                : applications[idx].status == ApplicationStatus.accepted
                                                                    ? '테스트 중'
                                                                    : applications[idx].status ==
                                                                            ApplicationStatus.cancel
                                                                        ? '취소'
                                                                        : "종료",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey.shade300,
                                                          fontWeight: FontWeight.bold,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 5),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(14),
                                                ),
                                                child: Text(
                                                    TypeConversionUtil().postCategoryToString(posts[idx].category!),
                                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                                              ),
                                              const Gap(10),
                                              _buttonBuilder(applications[idx].id!, applications[idx].status!,
                                                  constraints.maxWidth)
                                            ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, idx) => Gap(10),
                        itemCount: applications.length);
              },
            )),
      ),
    ));
  }

  Widget _buttonBuilder(int appId, ApplicationStatus state, double wid) {
    String message = '';
    if (state == ApplicationStatus.pending) {
      message = '신청 취소';
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomOutlineButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    final token = context.read<UserProvider>().token ?? '';
                    return TwoButtonConfirmAlert(
                        mainContent: '취소하면 재신청이 할 수 없습니다.',
                        subContent: '정말 취소하시겠습니까?',
                        confirmButtonName: '진행',
                        cancelButtonName: '취소',
                        onPressedConfirm: () {
                          context.read<AppBloc>().add(RequestCancelEvent(token, appId));
                          Get.back();
                          return;
                        },
                        onPressedCancel: () {
                          Get.back();
                          return;
                        });
                  });
            },
            text: message,
            wid: wid * 0.4,
            hei: 30,
          ),
        ],
      );
    } else if (state == ApplicationStatus.cancel) {
      message = '신청 취소된 프로덕트 입니다.';
    } else if (state == ApplicationStatus.rejected) {
      message = '승인 거부된 프로덕트 입니다.';
    } else if (state == ApplicationStatus.accepted) {
      message = '테스트 완료 후 리뷰를 남겨주세요.';
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text(message, style: TextStyle(fontSize: 14, color: Colors.grey))],
    );
  }
}
