import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/presentation/post_create_page.dart';
import 'package:test_us_app/presentation/post_detail_page.dart';
import 'package:test_us_app/presentation/provider/post_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';

import '../domain/entities/post_entity.dart';
import '../services/common_height_provider.dart';
import 'bloc/data_bloc/data_bloc.dart';
import 'bloc/data_bloc/data_event.dart';
import 'bloc/data_bloc/data_state.dart';

class PostTesterPage extends StatefulWidget {
  const PostTesterPage({super.key});

  @override
  State<PostTesterPage> createState() => _PostTesterPageState();
}

class _PostTesterPageState extends State<PostTesterPage> {
  // late String platform;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataBloc, DataState>(builder: (context, state) {
      if (state.state == DataLoadState.dataLoadState) {
        return SizedBox(child: Center(child: CircularProgressIndicator()));
      } else if (state.state == DataLoadState.postCreateCompletedState ||
          state.state == DataLoadState.postDeleteCompletedState ||
          state.state == DataLoadState.postUpdateCompletedState) {
        context.read<DataBloc>().add(RequestCompleteEvent());
      }

      return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Text("테스터 모집"),
        ),
        body: SingleChildScrollView(
          child: Container(
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _testerPost()),
        ),
      ));
    });
  }

  // Widget _webPost() {
  //   return Selector<PostProvider, List<PostEntity>>(
  //       selector: (context, provider) => provider.posts??[],
  //       builder: (context, webPost, child) {
  //         return SizedBox(
  //           width: MediaQuery.sizeOf(context).width - 40,
  //           child: Expanded(
  //             child: GridView.builder(
  //               shrinkWrap: true,
  //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                 crossAxisCount: 2,
  //                 crossAxisSpacing: 10,
  //                 mainAxisSpacing: 10,
  //               ),
  //               itemBuilder: (context, idx) {
  //                 return Container(
  //                   decoration: BoxDecoration(
  //                     color: Theme.of(context).colorScheme.surface,
  //                   ),
  //                   child: Text("$idx"),
  //                 );
  //               },
  //               itemCount: webPost.length,
  //             ),
  //           )
  //         );
  //       });
  // }

  Widget _testerPost() {
    return Selector<PostProvider, List<PostEntity>>(
        selector: (context, provider) => provider.posts ?? [],
        builder: (context, posts, child) {
          final hei = GetIt.I.get<ResponsiveHeightProvider>().hei ?? MediaQuery.sizeOf(context).height - 120;
          return SizedBox(
              width: MediaQuery.sizeOf(context).width - 40,
              height: hei - 40,
              child: posts.isEmpty
                  ? Center(child: Text("테스터 모집이 아직 없습니다."))
                  : Column(
                      children: [
                        const Gap(30),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, crossAxisSpacing: 30, mainAxisSpacing: 30, mainAxisExtent: 300),
                          itemBuilder: (context, idx) {
                            return GestureDetector(
                              onTap: () {
                                final token = context.read<UserProvider>().token ?? "";
                                context.read<DataBloc>().add(GetPostDetailEvent(context, posts[idx].id!, token));
                                Get.to(() => PostDetailPage(post: posts[idx]));
                              },
                              child: SizedBox(
                                child: Column(
                                  children: [
                                    Flexible(
                                        flex: 1,
                                        child: Container(
                                          height: 150,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: posts[idx].images!.isEmpty ? Border.all() : null),
                                          child: posts[idx].images!.isEmpty
                                              ? SizedBox(
                                                  child: Center(
                                                    child: Text('이미지가 없습니다.'),
                                                  ),
                                                )
                                              : ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: Image.network(
                                                    posts[idx].images![0]['url'],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                        )),
                                    const Gap(4),
                                    Flexible(
                                        flex: 1,
                                        child: SizedBox(
                                          height: 150,
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Text("${posts[idx].title}",
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                              const Gap(4),
                                              Text("${posts[idx].subtitle}",
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                                              const Gap(4),
                                              Text("${posts[idx].author!.nickname}")
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: posts.length,
                        ),
                      ],
                    ));
        });
  }
}
