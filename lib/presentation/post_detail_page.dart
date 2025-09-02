import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:test_us_app/presentation/post_create_page.dart';
import 'package:test_us_app/presentation/provider/post_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';

import '../domain/entities/post_entity.dart';
import 'bloc/data_bloc/data_bloc.dart';
import 'bloc/data_bloc/data_event.dart';
import 'bloc/data_bloc/data_state.dart';

class PostDetailPage extends StatefulWidget {
  final PostEntity? post;

  const PostDetailPage({super.key, this.post});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late PostEntity? _post;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.post != null) _post = widget.post!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataBloc, DataState>(builder: (context, state) {
      if (state.state == DataLoadState.postUpdateCompletedState) {
        _post = context.read<PostProvider>().posts!.firstWhere((element) {
          return element.id == _post!.id;
        });
        context.read<DataBloc>().add(RequestCompleteEvent());
      } else if (state.state == DataLoadState.errorState) {
        Get.snackbar("에러", "알 수 없는 문제로 수정 실패 했습니다.");
      }
      return SafeArea(
          child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              // bottom: PreferredSize(
              //   preferredSize: Size.fromHeight(100),
              //   child: Container(
              //     child: Text(";alskdjflaksdjlaksdf"),
              //   )
              // ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Platform.isAndroid
                    ? Icons.arrow_back
                    : Icons.arrow_back_ios_new),
              ),
              actions: [
                _post != null &&
                        widget.post!.author!.id ==
                            context.read<UserProvider>().user!.id
                    ? PopupMenuButton(
                        icon: Icon(Icons.more_vert_rounded),
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem(value: 1, child: Text("Edit")),
                            PopupMenuItem(value: 2, child: Text("Delete"))
                          ];
                        },
                        onSelected: (value) async {
                          if (value == 1) {
                            Get.to(PostCreatePage(post: _post));
                          } else if (value == 2) {
                            Get.defaultDialog(
                                title: "삭제",
                                middleText: "삭제하시겠습니까?",
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text("취소"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      final token =
                                          context.read<UserProvider>().token ??
                                              "";
                                      try {
                                        context.read<DataBloc>().add(
                                            RequestPostDeleteEvent(
                                                context, token, _post!.id!));
                                        Get.back();
                                      } on Exception catch (e) {
                                        // TODO
                                        Get.snackbar('알림', '삭제 실패');
                                      }
                                      Get.back();
                                    },
                                    child: Text("확인"),
                                  )
                                ]);
                          }
                        },
                      )
                    : SizedBox()
              ],
              expandedHeight: 300,
              // pinned: true,
            ),
            if (_post == null)
              SliverList(
                  key: const ValueKey("nullValue"),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => SizedBox(
                      height: 100,
                      child: Card(
                        child: Text(index.toString()),
                      ),
                    ),
                    childCount: 30,
                  ))
            else
              SliverToBoxAdapter(
                key: const ValueKey("postValue"),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          child: Text(
                        _post!.title!,
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      )),
                      const Gap(10),
                      SizedBox(
                          child: Text(_post!.subtitle!,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))),
                      const Gap(30),
                      SizedBox(child: Text(widget.post!.contents!)),
                      const Gap(40),
                      if (_post != null &&
                          widget.post!.author!.id !=
                              context.read<UserProvider>().user!.id)
                        Center(
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.sizeOf(context).width - 80,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: Text("테스터 신청"),
                            ),
                          ),
                        ),
                      if (_post != null &&
                          _post!.author!.id !=
                              context.read<UserProvider>().user!.id)
                        const Gap(80),
                    ],
                  ),
                ),
              )
          ],
        ),
      ));
    });
  }
}
