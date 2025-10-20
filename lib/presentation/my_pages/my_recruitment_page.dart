import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:test_us_app/domain/entities/post_entity.dart';
import 'package:test_us_app/presentation/bloc/data_bloc/data_event.dart';
import 'package:test_us_app/presentation/my_pages/application_management_page.dart';

import '../../data/models/application/application_model.dart';
import '../../data/models/post/post_model.dart';
import '../../services/common_height_provider.dart';
import '../bloc/data_bloc/data_bloc.dart';
import '../bloc/data_bloc/data_state.dart';
import '../provider/user_provider.dart';
import '../tester_post_pages/post_detail_page.dart';

class MyRecruitmentPage extends StatefulWidget {
  const MyRecruitmentPage({super.key});

  @override
  State<MyRecruitmentPage> createState() => _MyRecruitmentPageState();
}

class _MyRecruitmentPageState extends State<MyRecruitmentPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestRecruitmentPosts();
  }
  Future<void> _requestRecruitmentPosts() async {
    final token = context.read<UserProvider>().token ?? '';
    final userId = context.read<UserProvider>().user!.id ?? '';
    context.read<DataBloc>().add(RequestUserRecruitmentPosts(token, userId));
  }

  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei!;
    List<PostEntity> posts = [];
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("테스터 모집 관리"),
      ),
      body: BlocConsumer<DataBloc, DataState>(listener: (context, state) {
        if (state.state == DataLoadState.getUserRecruitmentPostsCompletedState) {
          // posts = state.posts!;
          // context.read<DataBloc>().add(RequestCompleteEvent());
        }
      }, builder: (context, state) {
        if (state.state == DataLoadState.dataLoadState) {
          return SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: hei,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state.posts != null) {
          if(state.posts!.isEmpty){
            return SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: hei,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('작성 된 모집글이 없습니다.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  const Gap(10),
                  Text('나만의 서비스가 있다면 테스터를'),
                  Text('모집해 보세요.'),
                ],
              ),
            ); 
          }
          return _postsInfoBuilder(state.posts!, hei);
        }
        return SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: hei,
          child: Center(
            child: Text('데이터 조회중 오류가 발생했습니다.'),
          ),
        );
      }),
    ));
  }

  Widget _postsInfoBuilder(List<PostEntity> posts, double hei) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: posts.isEmpty
              ? SizedBox()
              : ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 20),
              itemBuilder: (context, idx) {
                return SizedBox(
                  height: 70,
                  width: MediaQuery.sizeOf(context).width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 8,
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => PostDetailPage(post: posts[idx]));
                          },
                          child: Container(
                            width: (MediaQuery.sizeOf(context).width - 50) * 0.8,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              SizedBox(
                                height: 30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      posts[idx].title!,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis),
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      child: posts[idx].platform!.length == 1
                                          ? Text('플랫폼 : ${posts[idx].platform![0]}')
                                          : Text(
                                          '플랫폼 : ${posts[idx].platform![0]} / ${posts[idx].platform![1]}'),
                                    ),
                                    const Gap(20),
                                    SizedBox(
                                      child: posts[idx].status == PostStatus.active
                                          ? Text('(모집 중)')
                                          : (posts[idx].status == PostStatus.end
                                          ? Text('(기간 종료)')
                                          : Text('(만료)')),
                                    )
                                  ],
                                ),
                              )
                            ]),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: SizedBox(
                          height: 60,
                          width: (MediaQuery.sizeOf(context).width - 50) * 0.2,
                          child: ElevatedButton(
                            onPressed: _getApplicantLength(posts[idx]) == 0
                                ? null
                                : () {
                              Get.to(() => ApplicationManagementPage(postId: posts[idx].id!));
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('신청 인원', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                Text('(${_getApplicantLength(posts[idx])} / 8)'),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, idx) => const Gap(20),
              itemCount: posts.length)),
    );
  }
  int _getApplicantLength(PostEntity post) {
    int length = 0;
    if (post.applications != null) {
      for (final application in post.applications!) {
        if (application.status != ApplicationStatus.cancel || application.status == null) {
          length++;
        }
      }
    }
    return length;
  }
}
