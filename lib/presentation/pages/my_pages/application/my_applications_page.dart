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
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:test_us_app/utils/time_util.dart';

import '../../../../domain/entities/recruit_post_entity.dart';
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
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   final posts = context.read<ApplicationProvider>().userApplicationPosts ?? [];
  //   final app = context.read<ApplicationProvider>().userApplications ?? [];
  //   if (posts.isEmpty || posts.length != app.length) {
  //     final postIds = app.map((e) => e.postId!).toList();
  //     final token = context.read<UserProvider>().token ?? '';
  //     context.read<RecruitPostBloc>().add(RequestAppRecruitPosts(token, postIds));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
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
            child: Selector<ApplicationProvider, List<RecruitPostEntity>>(
              selector: (context, provider) => provider.userApplicationPosts ?? [],
              builder: (context, posts, child) {
                final hei = GetIt.I.get<ResponsiveHeightProvider>().hei ?? 0;
                return posts.isEmpty
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
                          return Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
                            // height: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => RecruitPostDetailPage(postId: posts[idx].id!));
                                  },
                                  child: Text(
                                    posts[idx].title!,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                // Text(posts[idx].subtitle!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                //   overflow: TextOverflow.ellipsis,
                                //   maxLines: 1,
                                // ),
                                const Gap(20),
                                Selector<ApplicationProvider, List<ApplicationEntity>>(
                                    selector: (context, provider) => provider.userApplications ?? [],
                                    builder: (context, applications, child) {
                                      return SizedBox(
                                        child: Column(
                                          children: [
                                            _buttonBuilder(applications[idx].status!, applications[idx].id!,
                                                applications[idx].postId!),
                                            const Gap(10),
                                            Text(
                                                '업데이트 : ${TimeUtil().getDateTimeString(applications[idx].updatedAt!, false)}')
                                          ],
                                        ),
                                      );
                                    })
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, idx) => Gap(10),
                        itemCount: posts.length);
              },
            )),
      ),
    ));
  }

  Widget _buttonBuilder(ApplicationStatus state, int appId, String postId) {
    final token = context.read<UserProvider>().token ?? '';
    if (state == ApplicationStatus.pending) {
      return SizedBox(
        height: 50,
        width: MediaQuery.sizeOf(context).width - 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: SizedBox(
                width: (MediaQuery.sizeOf(context).width - 60) * 0.2,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      context.read<AppBloc>().add(RequestCancelEvent(token, appId));
                    },
                    style: ElevatedButton.styleFrom(
                        // backgroundColor: Colors.grey,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    child: Text('취소')),
              ),
            ),
            const Gap(10),
            Flexible(
              flex: 8,
              child: SizedBox(
                width: (MediaQuery.sizeOf(context).width - 60) * 0.8,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => RecruitPostDetailPage(postId: postId));
                    },
                    style: ElevatedButton.styleFrom(
                        // backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                    child: Text('포스트로 이동')),
              ),
            ),
          ],
        ),
      );
    } else if (state == ApplicationStatus.rejected) {
      return Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('테스터 신청 거부', style: TextStyle(color: Colors.grey))],
          ));
    } else if (state == ApplicationStatus.accepted) {
      return Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('승인 완료(테스트 중)', style: TextStyle(color: Colors.grey))],
          ));
    }
    return SizedBox();
  }
}
