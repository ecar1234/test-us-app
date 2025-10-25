import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import 'package:test_us_app/domain/entities/recruit_post_entity.dart';
import 'package:test_us_app/presentation/bloc/app_bloc/app_event.dart';

import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/presentation/tester_post_pages/post_detail_page.dart';
import 'package:test_us_app/services/common_height_provider.dart';

import '../../domain/entities/image_entity.dart';
import '../bloc/image_bloc/image_bloc.dart';
import '../bloc/image_bloc/image_event.dart';
import '../bloc/image_bloc/image_state.dart';
import '../bloc/post_blocs/recruit_post_bloc/recruit_post_bloc.dart';
import '../bloc/post_blocs/recruit_post_bloc/recruit_post_event.dart';
import '../bloc/post_blocs/recruit_post_bloc/recruit_post_state.dart';
import '../provider/recruit_post_provider.dart';

class PostCreatePage extends StatefulWidget {
  final RecruitPostEntity? post;

  const PostCreatePage({super.key, this.post});

  @override
  State<PostCreatePage> createState() => _PostCreatePageState();
}

class _PostCreatePageState extends State<PostCreatePage> {
  final logger = Logger();
  final picker = ImagePicker();
  List<XFile> _selectedImages = [];
  List<ImageEntity> _existedImages = [];
  final List<ImageEntity> _deleteImages = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController periodController = TextEditingController(text: "7");

  final GlobalKey<TooltipState> tooltipKey = GlobalKey<TooltipState>();

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
      if (_selectedCategory.contains('Android')) {
        _androidCheck = true;
      }
      if (_selectedCategory.contains('GAME')) {
        _gameCheck = true;
      }
      if (widget.post!.images != null && widget.post!.images!.isNotEmpty) {
        _existedImages = widget.post!.images!;
      }
    }
  }

  @override
  void didUpdateWidget(covariant PostCreatePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.post?.images != oldWidget.post?.images) {
      setState(() {
        _existedImages = widget.post!.images!;
      });
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
                      // 이미지 추가
                      _addImageSection(),
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
                      _buttonSection(context),
                      const Gap(40)
                    ],
                  ),
                ),
              )),
        ));
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

  Widget _addImageSection() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width - 40,
      height: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    child: Text(
                  "서비스 이미지 추가 (${_existedImages.length + _selectedImages.length} / 4)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )),
                SizedBox(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _existedImages.length == 3
                          ? () async {
                              final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
                              if (image == null) {
                                return;
                              } else if (File(image.path).lengthSync() / (1024 * 1024) > 5) {
                                Get.snackbar('알림', '5MB를 초과하는 이미지는 업로드 할 수 없습니다.');
                                return;
                              } else if (_existedImages.length + _selectedImages.length >= 4) {
                                Get.snackbar('알림', '최대 4개의 이미지를 선택할 수 있습니다.');
                                return;
                              } else {
                                setState(() {
                                  _selectedImages.add(image);
                                });
                              }
                            }
                          : () async {
                              final images = await picker
                                  .pickMultiImage(
                                      imageQuality: 100,
                                      limit: _existedImages.isNotEmpty ? 4 - _existedImages.length : 4)
                                  .onError((e, state) {
                                Get.snackbar('알림', '이미지 선택에 실패했습니다.');
                                return [];
                              });
                              if (images.isEmpty) {
                                return;
                              } else if (images.length + _existedImages.length > 4) {
                                Get.snackbar('알림', '최대 4개의 이미지를 선택할 수 있습니다.');
                                return;
                              } else {
                                final sizeList = images.map((e) => File(e.path).lengthSync() / (1024 * 1024)).toList();
                                if (sizeList.any((element) => element > 5)) {
                                  Get.snackbar('알림', '5MB를 초과하는 이미지는 업로드 할 수 없습니다.');
                                  return;
                                }
                              }
                              if (_selectedImages.isEmpty) {
                                setState(() {
                                  _selectedImages = images;
                                });
                              } else {
                                setState(() {
                                  _selectedImages.addAll(images);
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      child: Text('추가'),
                    ))
              ],
            ),
          ),
          SizedBox(
              height: 120,
              width: MediaQuery.sizeOf(context).width - 40,
              child: _selectedImages.isEmpty && _existedImages.isEmpty
                  ? SizedBox(
                      child: Center(
                        child: Text('서비스 이미지를 추가해보세요.'),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, idx) {
                        if (idx >= _selectedImages.length + _existedImages.length) return SizedBox.shrink();
                        return SizedBox(
                          height: 110,
                          width: 110,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(children: [
                              if (idx < _existedImages.length)
                                Image.network(
                                  _existedImages[idx].url!,
                                  height: double.infinity,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              else
                                Image.file(
                                  File(_selectedImages[idx - _existedImages.length].path),
                                  height: double.infinity,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              //TODO: post로직 이미지 로직으로 변경 필요.
                              BlocListener<ImageBloc, ImageState>(
                                listener: (context, state) {
                                  if (state.state == ImageLoadState.imageDeleteCompletedState) {
                                    setState(() {
                                      _existedImages.removeAt(idx);
                                    });
                                    // context.read<DataBloc>().add(ReloadPostEvent());
                                  }
                                },
                                child: Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                        onTap: () {
                                          if (idx < _existedImages.length) {
                                            setState(() {
                                              _deleteImages.add(_existedImages[idx]);
                                            });
                                            setState(() {
                                              _existedImages.removeAt(idx);
                                            });
                                          } else {
                                            setState(() {
                                              _selectedImages.removeAt(idx - _existedImages.length);
                                            });
                                          }
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black.withValues(alpha: 0.5),
                                          ),
                                          child: Center(
                                            child: Icon(Icons.close),
                                          ),
                                        ))),
                              ),
                            ]),
                          ),
                        );
                      },
                      separatorBuilder: (context, idx) => const Gap(10),
                      itemCount: 4))
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
                          key: tooltipKey,
                          message: "모집기간은 광고시청(3일) 또는 인앱구매로 변경 가능 합니다.",
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          showDuration: const Duration(seconds: 3),
                          child: IconButton(
                            onPressed: () {
                              tooltipKey.currentState?.ensureTooltipVisible();
                            },
                            style: IconButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            icon: Icon(Icons.info_outline),
                          )))
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
                      decoration: InputDecoration(enabled: false),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const Gap(10),
                  SizedBox(child: Text("일", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
                ],
              ),
            )
          ],
        ));
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

  Widget _buttonSection(BuildContext context) {
    final token = context.read<UserProvider>().token ?? '';
    //TODO: post로직 이미지 로직으로 변경 필요.
    return MultiBlocListener(
      listeners: [
        BlocListener<RecruitPostBloc, RecruitPostState>(listener: (context, state) async {
          if (state.state == RecruitPostLoadState.postCreateCompletedState) {
            context.read<ImageBloc>().add(RequestPostImgRegisterEvent(token, _selectedImages, state.post!.id!));
          } else if (state.state == RecruitPostLoadState.postUpdateCompletedState) {
            context
                .read<ImageBloc>()
                .add(RequestPostImgUpdateEvent(token, _deleteImages, _selectedImages, state.post!.id!));
          }
        }),
        BlocListener<ImageBloc, ImageState>(listener: (context, state) async {
          final provider = context.read<RecruitPostProvider>();
          if (state.state == ImageLoadState.imageUploadCompletedState) {
            provider.createPost(state.post!);
            await _alertDialog(context, '등록');
            if (context.mounted) Navigator.pop(context);
          } else if (state.state == ImageLoadState.beforeImageUploadState) {
            provider.updatePost(state.post!);
            await _alertDialog(context, '수정');
            if (context.mounted) Navigator.pop(context);
          }
        })
      ],
      child: SizedBox(
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
                    if (titleController.text.isEmpty ||
                        subtitleController.text.isEmpty ||
                        contentController.text.isEmpty) {
                      Get.snackbar("알림", "모든 항목을 입력해주세요.");
                      return;
                    }
                    if (_selectedCategory.isEmpty) {
                      Get.snackbar("알림", "플랫폼을 선택해주세요.");
                      return;
                    }
                    final post = RecruitPostEntity(
                      title: titleController.text,
                      subtitle: subtitleController.text,
                      contents: contentController.text,
                      platform: _selectedCategory,
                      images: _selectedImages.map((e) => ImageEntity(url: e.path)).toList(),
                    );
                    Get.to(() => PostDetailPage(post: post));
                  },
                  style:
                      ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: Text("미리보기"),
                )),
            const Gap(20),
            if (widget.post == null)
              SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isEmpty ||
                        subtitleController.text.isEmpty ||
                        contentController.text.isEmpty) {
                      Get.snackbar("알림", "모든 항목을 입력해주세요.");
                      return;
                    }
                    if (_selectedCategory.isEmpty) {
                      Get.snackbar("알림", "플랫폼을 선택해주세요.");
                      return;
                    }
                    if (_selectedImages.isEmpty) {
                      Get.snackbar("알림", "최소 한장의 이미지를 선택해주세요.");
                      return;
                    }

                    context.read<RecruitPostBloc>().add(PostDataLoadEvent());
                    final post = RecruitPostEntity(
                      title: titleController.text,
                      subtitle: subtitleController.text,
                      contents: contentController.text,
                      platform: _selectedCategory,
                      author: context.read<UserProvider>().user,
                      period: 7,
                    );
                    final token = context.read<UserProvider>().token!;
                    try {
                      context.read<RecruitPostBloc>().add(RequestPostCreateEvent(token, post));
                    } on Exception catch (e) {
                      // TODO
                      logger.e(e);
                      Get.snackbar('알림', '등록 실패');
                      return;
                    }
                    // if (context.mounted) {
                    //   Get.back();
                    // }
                  },
                  style:
                      ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: Text("등록"),
                ),
              )
            else
              SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  onPressed: () async {
                    final post = RecruitPostEntity(
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
                      context.read<RecruitPostBloc>().add(RequestPostUpdateEvent(token, post));
                    } on Exception catch (e) {
                      logger.e(e);
                      Get.snackbar('알림', '수정 실패');
                    }

                    // Get.back();
                  },
                  style:
                      ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  child: Text("수정하기"),
                ),
              )
          ],
        ),
      ),
    );
  }

  Future<void> _alertDialog(BuildContext context, String content) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("게시 성공"),
          content: Text("테스터 모집글을 $content 했습니다.."),
          actions: [
            TextButton(
                onPressed: () {
                  context.read<RecruitPostBloc>().add(ReloadPostEvent());
                  Navigator.pop(context);
                },
                child: Text("확인"))
          ],
        );
      },
    );
  }
}
