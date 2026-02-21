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
            child: Selector<ApplicationProvider, List<RecruitPostEntity>>(
              selector: (context, provider) {
                // todo: createdAt 내림차순
                return provider.userApplicationPosts ?? [];
              },
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
                          bool isExpired =
                              posts[idx].status == PostStatus.expired || posts[idx].status == PostStatus.end;
                          final application = context
                              .read<ApplicationProvider>()
                              .userApplications!
                              .firstWhere((e) => e.postId == posts[idx].id);
                          return GestureDetector(
                            onTap: (){
                              if(posts[idx].status == PostStatus.end){
                                Get.snackbar('알림', '종료된 프로덕트 입니다.');
                                return;
                              }
                              Get.to(() => RecruitPostDetailPage(postId: posts[idx].id!));
                            },
                            child: Container(
                              // height: 150,
                              width: MediaQuery.sizeOf(context).width,
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
                              child: LayoutBuilder(
                                builder: (context, constraints) => Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                        flex: 3,
                                        child: SizedBox(
                                            width: constraints.maxWidth * 0.4,
                                            height: 150,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                imageUrl: posts[idx].images![0].url!,
                                                fit: BoxFit.cover,
                                                color: isExpired ? Colors.grey.shade200 : null,
                                                colorBlendMode: isExpired ? BlendMode.saturation : null,
                                              ),
                                            ))),
                                    Flexible(
                                      flex: 7,
                                      child: Container(
                                        height: 150,
                                        width: constraints.maxWidth * 0.7,
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 30,
                                                child: Text(
                                                  posts[idx].title!,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      overflow: TextOverflow.ellipsis),
                                                  maxLines: 1,
                                                ),
                                              ),
                                              SizedBox(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(posts[idx].platform!.name.toUpperCase(),
                                                        style: TextStyle(color: Colors.grey.shade600)),
                                                    if (posts[idx].platform == ApplicationPlatform.mobile)
                                                      Text('(${TypeConversionUtil().getPostOs(posts[idx].mobileOs??MobileOsType.ios)})',
                                                          style: TextStyle(color: Colors.grey.shade600))
                                                  ],
                                                ),
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
                                              SizedBox(
                                                child: Text('${posts[idx].author!.nickname}',
                                                    style: TextStyle(
                                                        color: Colors.grey.shade600,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500)),
                                              ),
                                              const Gap(10),
                                               _buttonBuilder(posts[idx].status! ,application.status!, constraints.maxWidth)
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
                        itemCount: posts.length);
              },
            )),
      ),
    ));
  }

  Widget _buttonBuilder(PostStatus postState, ApplicationStatus state, double wid) {
    String message = '';
    if(postState == PostStatus.end){
      message = '테스트 종료';
    } else if (state == ApplicationStatus.pending) {
      message = '테스터 신청 중';
    } else if (state == ApplicationStatus.rejected) {
      message ='테스터 신청 미승인';
    } else if (state == ApplicationStatus.accepted) {
      message = '테스터 선정(테스트 진행 중)';
    }
    return Container(
        height: 40,
        width: wid,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child:Text(message)));
  }
}
