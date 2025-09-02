import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/presentation/post_create_page.dart';
import 'package:test_us_app/presentation/post_detail_page.dart';
import 'package:test_us_app/presentation/provider/post_provider.dart';

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
      }else if(state.state == DataLoadState.postCreateCompletedState || state.state == DataLoadState.postDeleteCompletedState ||
          state.state == DataLoadState.postUpdateCompletedState){
        context.read<DataBloc>().add(RequestCompleteEvent());
      }

      return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Text("테스터 모집"),
        ),
        body: Container(
            width: MediaQuery.sizeOf(context).width,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child:
            // platform == 'web' ? _webPost() :
            _testerPost()
        ),
      ));
    });
  }

  Widget _webPost() {
    return Selector<PostProvider, List<PostEntity>>(
        selector: (context, provider) => provider.posts??[],
        builder: (context, webPost, child) {
          return SizedBox(
            width: MediaQuery.sizeOf(context).width - 40,
            child: Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, idx) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Text("$idx"),
                  );
                },
                itemCount: webPost.length,
              ),
            )
          );
        });
  }

  Widget _testerPost() {
    return Selector<PostProvider, List<PostEntity>>(
        selector: (context, provider) => provider.posts??[],
        builder: (context, posts, child) {
          final hei = GetIt.I.get<ResponsiveHeightProvider>().hei ?? MediaQuery.sizeOf(context).height - 120;
          return SizedBox(
              width: MediaQuery.sizeOf(context).width - 40,
              height: hei - 40,
              child: posts.isEmpty ?
                  Center(child: Text("게시글이 아직 없습니다."))
                  : GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 30,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, idx) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(PostDetailPage(post: posts[idx]));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      child: SizedBox(
                        child: Column(
                          children: [
                            Flexible(
                              flex: 2,
                              child: Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  border: Border.all()
                                ),
                                child: Center(child: Text("Main Image")),
                              )
                            ),
                            const Gap(10),
                            Flexible(
                              flex: 1,
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text("${posts[idx].title}"),
                                    Text("${posts[idx].subtitle}"),
                                    Text("${posts[idx].author!.nickname}")
                                  ],
                                ),
                              )
                            ),
                          ],
                        ),
                      )
                    ),
                  );
                },
                itemCount: posts.length,
              )
          );
        });
  }
}
