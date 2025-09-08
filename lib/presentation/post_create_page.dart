import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:material_symbols_icons/symbols.dart';

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
  TextEditingController periodController = TextEditingController(text: "7");

  final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();

  // final _categoryList = ['WEB', 'IOS', 'ANDROID'];
  List<String> _selectedCategory = [];

  bool _webCheck = false;
  bool _iosCheck = false;
  bool _androidCheck = false;
  bool _gameCheck = false;

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
      if (_selectedCategory.contains('GAME')) {
        _gameCheck = true;
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
    return BlocBuilder<DataBloc, DataState>(
      builder: (context, state) {
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
                          _titleSection(),
                          const Gap(20),
                          // 서비스 요약
                          _subtitleSection(),
                          const Gap(20),
                          // 게시 기간
                          _periodSection(),
                          const Gap(20),
                          // 카테고리
                          _categorySection(),
                          const Gap(20),
                          // 서비스 설명
                          _contentSection(),
                          const Gap(40),
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
                                        if(titleController.text.isEmpty || subtitleController.text.isEmpty || contentController.text.isEmpty){
                                          Get.snackbar("알림", "모든 항목을 입력해주세요.");
                                          return;
                                        }
                                        if(_selectedCategory.isEmpty){
                                          Get.snackbar("알림", "플랫폼을 선택해주세요.");
                                          return;
                                        }
                                        final post = PostEntity(
                                          title: titleController.text,
                                          subtitle: subtitleController.text,
                                          contents: contentController.text,
                                          platform: _selectedCategory,
                                        );
                                        Get.to(() => PostDetailPage(post: post));
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                      child: Text("미리보기"),
                                    )),
                                const Gap(20),
                                if (widget.post == null)
                                  SizedBox(
                                      height: 50,
                                      width: 150,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if(titleController.text.isEmpty || subtitleController.text.isEmpty || contentController.text.isEmpty){
                                            Get.snackbar("알림", "모든 항목을 입력해주세요.");
                                            return;
                                          }
                                          if(_selectedCategory.isEmpty){
                                            Get.snackbar("알림", "플랫폼을 선택해주세요.");
                                            return;
                                          }
                                          final post = PostEntity(
                                            title: titleController.text,
                                            subtitle: subtitleController.text,
                                            contents: contentController.text,
                                            platform: _selectedCategory,
                                            author: context.read<UserProvider>().user,
                                            period: 7,
                                          );
                                          final token = context.read<UserProvider>().token!;
                                          try {
                                            context.read<DataBloc>().add(RequestPostCreateEvent(context, post, token));

                                            if (state.state == DataLoadState.postCreateCompletedState) {
                                              if (context.mounted) {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text("게시 성공"),
                                                      content: Text("모집글 등록에 성공하였습니다."),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(context);
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
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
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
                                              author: context.read<UserProvider>().user);
                                          final token = context.read<UserProvider>().token ?? "";
                                          try {
                                            context.read<DataBloc>().add(RequestPostUpdateEvent(context, token, post));
                                          } on Exception catch (e) {
                                            // TODO
                                            logger.e(e);
                                            Get.snackbar('알림', '수정 실패');
                                          }

                                          Get.back();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                        child: Text("수정하기"),
                                      ))
                              ],
                            ),
                          ),
                          const Gap(40)
                        ],
                      ),
                    ),
                  )),
            ));
      },
    );
  }

  Widget _titleSection() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Text(
              "서비스 네임",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Gap(10),
          SizedBox(
            height: 60,
            child: TextField(
              controller: titleController,
            ),
          )
        ],
      ),
    );
  }

  Widget _subtitleSection() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Text(
              "서비스 요약",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Gap(10),
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
    );
  }

  Widget _periodSection() {
    return SizedBox(
      // height: 200,
      width: MediaQuery.sizeOf(context).width - 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Row(
              children: [
                SizedBox(
                  child: Text(
                    "모집 기간",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const Gap(10),
                SizedBox(
                  height: 20,
                  width: 20,
                  child: Tooltip(
                    key: tooltipkey,
                    message: "모집기간은 광고시청(3일) 또는 인앱구매로 변경 가능 합니다.",
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    showDuration: const Duration(seconds: 3),
                    child: IconButton(
                      onPressed: () {
                        tooltipkey.currentState?.ensureTooltipVisible();
                      },
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      icon: Icon(Icons.info_outline),

                    )
                  )
                )
              ],
            ),
          ),
          const Gap(10),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 80,
                  child: TextField(
                    controller: periodController,
                    readOnly: true,
                    // enabled: false,
                    decoration: InputDecoration(
                      enabled: false
                    ),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                ),
                const Gap(10),
                SizedBox(
                  child: Text("일", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                )
              ],
            ),
          )
        ],
      )
    );
  }

  Widget _categorySection() {
    return SizedBox(
        width: MediaQuery.sizeOf(context).width - 40,
        // height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                child: Text(
              "플랫폼",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
            const Gap(10),
            SizedBox(
                child: GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 3.5,
                    children: [
                  SizedBox(
                      height: 30,
                      child: Row(
                        children: [
                          Checkbox(
                            value: _webCheck,
                            onChanged: (value) {
                              setState(() {
                                _webCheck = value!;
                                if (_webCheck) {
                                  _selectedCategory.add('WEB');
                                  if (_iosCheck) {
                                    _selectedCategory.remove('IOS');
                                    _iosCheck = false;
                                  }
                                  if (_androidCheck) {
                                    _selectedCategory.remove('Android');
                                    _androidCheck = false;
                                  }
                                  if (_gameCheck) {
                                    _selectedCategory.remove('GAME');
                                    _gameCheck = false;
                                  }
                                } else {
                                  _selectedCategory.remove('WEB');
                                }
                              });
                            },
                          ),
                          Text(
                            "WEB",
                            style: TextStyle(fontSize: 14, fontWeight: _webCheck ? FontWeight.bold : FontWeight.normal),
                          )
                        ],
                      )),
                  SizedBox(
                      height: 30,
                      child: Row(
                        children: [
                          Checkbox(
                            value: _gameCheck,
                            onChanged: (value) {
                              setState(() {
                                _gameCheck = value!;
                                if (_gameCheck) {
                                  _selectedCategory.add('GAME');
                                  if (_webCheck) {
                                    _selectedCategory.remove('WEB');
                                    _webCheck = false;
                                  }
                                  if (_iosCheck) {
                                    _selectedCategory.remove('IOS');
                                    _iosCheck = false;
                                  }
                                  if (_androidCheck) {
                                    _selectedCategory.remove('Android');
                                    _androidCheck = false;
                                  }
                                } else {
                                  _selectedCategory.remove('GAME');
                                }
                              });
                            },
                          ),
                          Text(
                            "GAME",
                            style:
                                TextStyle(fontSize: 14, fontWeight: _gameCheck ? FontWeight.bold : FontWeight.normal),
                          )
                        ],
                      )),
                  SizedBox(
                      height: 30,
                      child: Row(
                        children: [
                          Checkbox(
                            value: _iosCheck,
                            onChanged: (value) {
                              setState(() {
                                _iosCheck = value!;
                                if (_iosCheck) {
                                  _selectedCategory.add('IOS');
                                  if (_webCheck) {
                                    _selectedCategory.remove('WEB');
                                    _webCheck = false;
                                  }
                                  if (_gameCheck) {
                                    _selectedCategory.remove('GAME');
                                    _gameCheck = false;
                                  }
                                } else {
                                  _selectedCategory.remove('IOS');
                                }
                              });
                            },
                          ),
                          Text(
                            "IOS",
                            style: TextStyle(fontSize: 14, fontWeight: _iosCheck ? FontWeight.bold : FontWeight.normal),
                          )
                        ],
                      )),
                  SizedBox(
                      height: 30,
                      child: Row(
                        children: [
                          Checkbox(
                            value: _androidCheck,
                            onChanged: (value) {
                              setState(() {
                                _androidCheck = value!;
                                if (_androidCheck) {
                                  _selectedCategory.add('Android');
                                  if (_webCheck) {
                                    _selectedCategory.remove('WEB');
                                    _webCheck = false;
                                  }
                                  if (_gameCheck) {
                                    _selectedCategory.remove('GAME');
                                    _gameCheck = false;
                                  }
                                } else {
                                  _selectedCategory.remove('Android');
                                }
                              });
                            },
                          ),
                          Text(
                            "Android",
                            style: TextStyle(
                                fontSize: 14, fontWeight: _androidCheck ? FontWeight.bold : FontWeight.normal),
                          )
                        ],
                      )),
                ]))
          ],
        ));
  }

  Widget _contentSection() {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei!;
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Text(
              "서비스 설명",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Gap(10),
          SizedBox(
            height: hei * 0.5,
            child: TextField(
              controller: contentController,
              minLines: 20,
              maxLines: 20,
            ),
          )
        ],
      ),
    );
  }
}
