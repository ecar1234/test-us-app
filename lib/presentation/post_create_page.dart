import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

// import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/domain/entities/post_entity.dart';
import 'package:test_us_app/presentation/bloc/data_bloc/data_bloc.dart';
import 'package:test_us_app/presentation/post_detail_page.dart';
import 'package:test_us_app/presentation/provider/post_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/services/common_height_provider.dart';

import 'bloc/data_bloc/data_event.dart';
import 'bloc/data_bloc/data_state.dart';

class PostCreatePage extends StatefulWidget {
  final PostEntity? post;

  const PostCreatePage({super.key, this.post});

  @override
  State<PostCreatePage> createState() => _PostCreatePageState();
}

class _PostCreatePageState extends State<PostCreatePage> {
  final logger = Logger();
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  final _categoryList = ['WEB', 'IOS', 'ANDROID'];
  List<String> _selectedCategory = [];

  bool _webCheck = false;
  bool _iosCheck = false;
  bool _androidCheck = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.post != null) {
      titleController.text = widget.post!.title!;
      subtitleController.text = widget.post!.subtitle!;
      contentController.text = widget.post!.contents!;
      _selectedCategory = widget.post!.platform!;
      if (_selectedCategory.contains('WEB')) {
        _webCheck = true;
      }
      if (_selectedCategory.contains('IOS')) {
        _iosCheck = true;
      }
      if (_selectedCategory.contains('ANDROID')) {
        _androidCheck = true;
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    subtitleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei!;
    return BlocBuilder<DataBloc, DataState>(
      builder:(context, state) {
        return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SafeArea(
              child: Scaffold(
                  appBar: AppBar(
                    title: Text("테스터 모집"),
                  ),
                  body: SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.sizeOf(context).width,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // 서비스 명
                          SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  child: Text(
                                    "서비스 네임",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 60,
                                  child: TextField(
                                    controller: titleController,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Gap(10),
                          // 서비스 요약
                          SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  child: Text(
                                    "서비스 설명",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 80,
                                  child: TextField(
                                    controller: subtitleController,
                                    maxLines: 1,
                                    maxLength: 30,
                                    // decoration: InputDecoration(
                                    //   counterText: "30",
                                    // ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Gap(10),
                          // 카테고리
                          SizedBox(
                              width: MediaQuery.sizeOf(context).width - 40,
                              height: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      child: Text(
                                    "플랫폼",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  const Gap(10),
                                  SizedBox(
                                      height: 50,
                                      child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, idx) {
                                            return SizedBox(
                                              width: (MediaQuery.sizeOf(context)
                                                          .width -
                                                      40) /
                                                  3,
                                              child: Row(
                                                children: [
                                                  Checkbox(
                                                      value: idx == 0
                                                          ? _webCheck
                                                          : (idx == 1
                                                              ? _iosCheck
                                                              : _androidCheck),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          if (idx == 0) {
                                                            if (_iosCheck ||
                                                                _androidCheck) {
                                                              Get.snackbar("알림",
                                                                  "Mobile 서비스가 이미 선택 되었있습니다.");
                                                              return;
                                                            }
                                                            _selectedCategory.add(
                                                                _categoryList[
                                                                    idx]);
                                                            _webCheck = value!;
                                                          } else if (idx == 1) {
                                                            if (_webCheck) {
                                                              Get.snackbar("알림",
                                                                  "Web 서비스가 이미 선택 되었있습니다.");
                                                              return;
                                                            }
                                                            _selectedCategory.add(
                                                                _categoryList[
                                                                    idx]);
                                                            _iosCheck = value!;
                                                          } else {
                                                            if (_webCheck) {
                                                              Get.snackbar("알림",
                                                                  "Web 서비스가 이미 선택 되었있습니다.");
                                                              return;
                                                            }
                                                            _selectedCategory.add(
                                                                _categoryList[
                                                                    idx]);
                                                            _androidCheck =
                                                                value!;
                                                          }
                                                        });
                                                      },
                                                      // checkColor: Colors.green,
                                                      fillColor:
                                                          WidgetStateProperty
                                                              .resolveWith(
                                                                  (state) {
                                                        if (state.contains(
                                                            WidgetState
                                                                .selected)) {
                                                          return Colors.blue;
                                                        }
                                                        return Colors.white;
                                                      })),
                                                  Text(_categoryList[idx]),
                                                ],
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, idx) =>
                                              const Gap(1),
                                          itemCount: _categoryList.length))
                                ],
                              )),
                          const Gap(10),
                          // 서비스 설명
                          SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  child: Text(
                                    "서비스 설명",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: hei * 0.4,
                                  child: TextField(
                                    controller: contentController,
                                    minLines: 20,
                                    maxLines: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Gap(20),
                          // 버튼
                          SizedBox(
                            height: 50,
                            width: MediaQuery.sizeOf(context).width - 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: 50,
                                    width: 150,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        final post = PostEntity(
                                          title: titleController.text,
                                          subtitle: subtitleController.text,
                                          contents: contentController.text,
                                          platform: _selectedCategory,
                                        );
                                        Get.to(
                                            () => PostDetailPage(post: post));
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      child: Text("미리보기"),
                                    )),
                                const Gap(20),
                                if (widget.post == null)
                                  SizedBox(
                                      height: 50,
                                      width: 150,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          final post = PostEntity(
                                              title: titleController.text,
                                              subtitle: subtitleController.text,
                                              contents: contentController.text,
                                              platform: _selectedCategory,
                                              author: context
                                                  .read<UserProvider>()
                                                  .user,
                                              period: 7,
                                          );
                                          final token = context
                                              .read<UserProvider>()
                                              .token!;
                                          try {
                                            context.read<DataBloc>().add(
                                                RequestPostCreateEvent(
                                                    context, post, token));

                                            if (state.state == DataLoadState.postCreateCompletedState) {
                                              if (context.mounted) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text("게시 성공"),
                                                      content: Text(
                                                          "모집글 등록에 성공하였습니다."),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text("확인"))
                                                      ],
                                                    );
                                                  },
                                                );
                                                return;
                                              }
                                            }
                                            Navigator.pop(context);
                                          } on Exception catch (e) {
                                            // TODO
                                            logger.e(e);
                                            Get.snackbar('알림', '등록 실패');
                                            return;
                                          }
                                          if (context.mounted) {
                                            Get.back();
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        child: Text("등록"),
                                      ))
                                else
                                  SizedBox(
                                      height: 50,
                                      width: 150,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          final post = PostEntity(
                                              id: widget.post!.id,
                                              title: titleController.text,
                                              subtitle: subtitleController.text,
                                              contents: contentController.text,
                                              platform: _selectedCategory,
                                              status: widget.post!.status,
                                              period: widget.post!.period,
                                              author: context
                                                  .read<UserProvider>()
                                                  .user);
                                          final token = context
                                                  .read<UserProvider>()
                                                  .token ??
                                              "";
                                          try {
                                            context.read<DataBloc>().add(
                                                RequestPostUpdateEvent(
                                                    context, token, post));
                                          } on Exception catch (e) {
                                            // TODO
                                            logger.e(e);
                                            Get.snackbar('알림', '수정 실패');
                                          }

                                          Get.back();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        child: Text("수정하기"),
                                      ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
            ));
      },
    );
  }
}
