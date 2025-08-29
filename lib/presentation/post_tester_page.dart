import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/presentation/post_create_page.dart';
import 'package:test_us_app/presentation/provider/post_provider.dart';

import '../domain/entities/post_entity.dart';
import '../services/common_height_provider.dart';
import 'bloc/data_bloc.dart';
import 'bloc/data_state.dart';

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
      // if (state.state == DataLoadState.dataLoadState) {
      //   return CircularProgressIndicator();
      // } else if (state.state == DataLoadState.webDataLoadCompletedState) {
      //   platform = 'web';
      //   debugPrint('web post : ${context.watch<PostProvider>().webPost}');
      // } else if (state.state == DataLoadState.mobileDataLoadCompletedState) {
      //   platform = 'mobile';
      //   debugPrint('app post : ${context.watch<PostProvider>().mobilePost}');
      // }

      return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Text("테스터 모집"),
        ),
        body: SingleChildScrollView(
            child: Container(
                width: MediaQuery.sizeOf(context).width,
                padding: EdgeInsets.all(20),
                child:
                // platform == 'web' ? _webPost() :
                _testerPost()
            )),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     Get.to(() => PostCreatePage());
            //   },
            //   child: Icon(Icons.add),
            // ),
      ));
    });
  }

  Widget _webPost() {
    return Selector<PostProvider, List<PostEntity>>(
        selector: (context, provider) => provider.posts,
        builder: (context, webPost, child) {
          return SizedBox(
            width: MediaQuery.sizeOf(context).width - 40,
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
            )
          );
        });
  }

  Widget _testerPost() {
    return Selector<PostProvider, List<PostEntity>>(
        selector: (context, provider) => provider.posts,
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
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, idx) {
                  return Container(
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
                          Flexible(
                            flex: 1,
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              child: Column(
                                children: [
                                  Text("${posts[idx].title}}"),
                                  Text("${posts[idx].subtitle}}"),
                                ],
                              ),
                            )
                          ),
                        ],
                      ),
                    )
                  );
                },
                itemCount: posts.length,
              )
          );
        });
  }
}
