import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:test_us_app/data/models/application/application_model.dart';
import 'package:test_us_app/domain/entities/promotion_post_entity.dart';
import 'package:test_us_app/presentation/pages/post/promotion_post_pages/promotion_post_detail_page.dart';

import '../../../../data/models/post/recruit_post_model.dart';
import '../../../../domain/entities/image_entity.dart';
import '../../../../domain/entities/recruit_post_entity.dart';
import '../../../../services/common_height_provider.dart';
import '../../../../utils/type_conversion_util.dart';
import '../../../bloc/post_blocs/promotion_bloc/promotion_bloc.dart';
import '../../../bloc/post_blocs/promotion_bloc/promotion_event.dart';
import '../../../bloc/post_blocs/promotion_bloc/promotion_state.dart';

import '../../../provider/post_provider/base_post_provider.dart';
import '../../../provider/user_provider.dart';
import '../tester_post_pages/recruit_post_detail_page.dart';

class PromotionPostCreatePage extends StatefulWidget {
  final PromotionPostEntity? post;

  const PromotionPostCreatePage({super.key, this.post});

  @override
  State<PromotionPostCreatePage> createState() => _PromotionPostCreatePageState();
}

class _PromotionPostCreatePageState extends State<PromotionPostCreatePage> {
  final logger = Logger();
  final picker = ImagePicker();
  List<XFile> _selectedImages = [];
  List<ImageEntity> _existedImages = [];
  final List<ImageEntity> _deleteImages = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _periodController = TextEditingController(text: "7");
  final TextEditingController _webUrlController = TextEditingController();
  final TextEditingController _gameUrlController = TextEditingController();
  final TextEditingController _iosUrlController = TextEditingController();
  final TextEditingController _androidUrlController = TextEditingController();

  final GlobalKey<TooltipState> tooltipKey = GlobalKey<TooltipState>();

  // final _categoryList = ['WEB', 'Mobile'];
  ApplicationPlatform? _selectedPlatform;

  bool _webCheck = false;
  bool _mobileCheck = false;
  bool _iosCheck = false;
  bool _androidCheck = false;

  List<MobileOsType> _selectedOs = [];
  PostCategory? _selectedCategory = PostCategory.game;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.post != null) {
      _titleController.text = widget.post!.title!;
      _subtitleController.text = widget.post!.subtitle!;
      _contentController.text = widget.post!.contents!;

      if (widget.post!.domain!.length < 2) {
        if (widget.post!.platform == ApplicationPlatform.web) {
          _webUrlController.text = widget.post!.domain!.isNotEmpty ? widget.post!.domain![0] : '';
          ;
        } else {
          _gameUrlController.text = widget.post!.domain!.isNotEmpty ? widget.post!.domain![0] : '';
        }
      } else {
        for (int i = 0; i < widget.post!.domain!.length; i++) {
          if (widget.post!.domain![i].contains('apps.apple.com')) {
            _iosUrlController.text = widget.post!.domain![i];
          } else if (i == 1) {
            _androidUrlController.text = widget.post!.domain![i];
          }
        }
      }

      _selectedPlatform = widget.post!.platform!;
      if (_selectedPlatform == ApplicationPlatform.web) {
        _webCheck = true;
      }
      if (_selectedPlatform == ApplicationPlatform.mobile) {
        _mobileCheck = true;
        _selectedOs = widget.post!.mobileOs!;
      }
      if(widget.post!.category != null) {
        _selectedCategory = widget.post!.category!;
      }

      if (widget.post!.images != null && widget.post!.images!.isNotEmpty) {
        _existedImages = widget.post!.images!;
      }
    }
  }

  @override
  void didUpdateWidget(covariant PromotionPostCreatePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.post?.images != oldWidget.post?.images) {
      setState(() {
        _existedImages = widget.post!.images!;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _subtitleController.dispose();
    _contentController.dispose();
    _periodController.dispose();
    _webUrlController.dispose();
    _gameUrlController.dispose();
    _iosUrlController.dispose();
    _androidUrlController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                title: Text("서비스 홍보"),
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
                      // 플랫폼
                      _platformSection(),
                      const Gap(20),
                      // 서비스 URL
                      _serviceUrlSection(),
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
              controller: _titleController,
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
              controller: _subtitleController,
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
                        child: Text('서비스 이미지를 추가해보세요.', style: TextStyle(fontSize: 16, color: Colors.grey)),
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
                              Positioned(
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
                      controller: _periodController,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                child: Text(
                  "카테고리",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
            ),
            const Gap(10),
            SizedBox(
                child: DropdownMenu(
                    menuHeight: 200,
                    initialSelection: _selectedCategory,
                    onSelected: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    dropdownMenuEntries: List.generate(
                        PostCategory.values.length,
                            (index) {
                          return DropdownMenuEntry(
                            value: PostCategory.values[index],
                            label: TypeConversionUtil().postCategoryToString(PostCategory.values[index]),
                          );
                        }
                    ))
            )
          ],
        )
    );
  }

  Widget _platformSection() {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Checkbox(
                          value: _webCheck,
                          onChanged: (value) {
                            setState(() {
                              _webCheck = value!;
                              _selectedPlatform = ApplicationPlatform.web;
                              if (value == true && _mobileCheck == true) {
                                _mobileCheck = false;
                                _androidCheck = false;
                                _iosCheck = false;
                              }
                            });
                          }),
                      Text(
                        'Web Service',
                        style: TextStyle(fontSize: 14, fontWeight: _webCheck ? FontWeight.bold : FontWeight.normal),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      Checkbox(
                          value: _mobileCheck,
                          onChanged: (value) async {
                            setState(() {
                              _mobileCheck = value!;
                              _selectedPlatform = ApplicationPlatform.mobile;
                              if (value == true && _webCheck == true) {
                                _webCheck = false;
                              }
                            });
                            if (value == true) {
                             final res = await showModalBottomSheet(
                              context: context,
                              isDismissible: false,
                              builder: (context) {
                                return _mobileOsSection();
                              });
                             if(res['android'] == true) {
                               setState(() {
                                  _androidCheck = true;
                                });
                             }
                             if(res['ios'] == true) {
                               setState(() {
                                  _iosCheck = true;
                                });
                             }
                            } else {
                              setState(() {
                                _selectedOs = [];
                                _androidCheck = false;
                                _iosCheck = false;
                              });
                            }
                            setState(() {
                              if (_androidCheck == true) {
                                _selectedOs.add(MobileOsType.ios);
                              } else {
                                _selectedOs.remove(MobileOsType.ios);
                              }

                              if (_iosCheck == true) {
                                _selectedOs.add(MobileOsType.android);
                              } else {
                                _selectedOs.remove(MobileOsType.android);
                              }
                            });
                          }),
                      Text(
                        'Mobile Service',
                        style: TextStyle(fontSize: 14, fontWeight: _mobileCheck ? FontWeight.bold : FontWeight.normal),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ));
  }

  Widget _mobileOsSection() {
    bool android = false;
    bool ios = false;
    return StatefulBuilder(
      builder: (context, setState) => Container(
        height: 280,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                child: Text(
              "모바일 OS",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
            const Gap(10),
            SizedBox(
                width: MediaQuery.sizeOf(context).width - 40,
                height: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Checkbox(
                                    value: android,
                                    onChanged: (value) {
                                      setState(() {
                                        android = value!;
                                      });
                                    }),
                                Text(
                                  'Android OS',
                                  style: TextStyle(
                                      fontSize: 14, fontWeight: android ? FontWeight.bold : FontWeight.normal),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            child: Row(
                              children: [
                                Checkbox(
                                    value: ios,
                                    onChanged: (value) {
                                      setState(() {
                                        ios = value!;
                                      });
                                    }),
                                Text(
                                  'IOS',
                                  style: TextStyle(
                                      fontSize: 14, fontWeight: ios ? FontWeight.bold : FontWeight.normal),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 3,
                          child: SizedBox(
                            height: 50,
                            width: (MediaQuery.sizeOf(context).width - 40) * 0.3,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Theme.of(context).primaryColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                                )
                              ),
                              child: Text("취소"),
                            ),
                          ),
                        ),
                        const Gap(20),
                        Flexible(
                          flex: 7,
                          child: SizedBox(
                            height: 50,
                            width: (MediaQuery.sizeOf(context).width - 40) * 0.7,
                            child: ElevatedButton(
                              onPressed: () {
                                if (!ios && !android) {
                                  Get.snackbar("알림", "OS를 선택해주세요.");
                                  return;
                                }

                                Navigator.pop(context, {'android': android, 'ios': ios});
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                                )
                              ),
                              child: Text("확인", style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _serviceUrlSection() {
    return SizedBox(
        width: MediaQuery.sizeOf(context).width - 40,
        // height: 150,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
              child: Text(
            "서비스 URL",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )),
          const Gap(10),
          SizedBox(
            child: Column(
              children: [
                if (!_webCheck && !_mobileCheck)
                  SizedBox(
                      height: 60,
                      width: MediaQuery.sizeOf(context).width - 40,
                      child: Center(child: Text('플랫폼을 선택해 주세요.', style: TextStyle(fontSize: 16, color: Colors.grey)))),
                if (_webCheck) _urlTextFiled(context, '웹사이트', _webUrlController),
                if (_mobileCheck)
                  Column(
                    children: [
                      if(_androidCheck)
                      _urlTextFiled(context, 'Play Store', _androidUrlController),
                      if(_iosCheck)
                      _urlTextFiled(context, 'App Store', _iosUrlController)
                    ])
              ],
            ),
          )
        ]));
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
              controller: _contentController,
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
    return BlocListener<PromotionBloc, PromotionPostState>(
        listener: (context, state) async {
          // NOTE: Recruit Post는 페이지 접속 시 새로 불러옴.
          // NOTE: init post의 Recruit post에만 추가 필요. CRUD 모두 적용
          final provider = context.read<BasePostProvider>();
          if (state.state == PromotionPostLoadState.postCreateCompletedState) {
            provider.createPromotionPost(state.post!);
            await _alertDialog(context, '등록');
          } else if (state.state == PromotionPostLoadState.postUpdateCompletedState) {
            provider.updatePromotionPost(state.post!);
            provider.updateUserPromotionPosts(state.post!);
            await _alertDialog(context, '수정');
          } else if (state.state == PromotionPostLoadState.errorState ||
              state.state == PromotionPostLoadState.failedState) {
            Get.snackbar('알림', '등록 실패');
            return;
          }
        },
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
                    onPressed: () async {
                      if (_titleController.text.isEmpty ||
                          _subtitleController.text.isEmpty ||
                          _contentController.text.isEmpty) {
                        Get.snackbar("알림", "모든 항목을 입력해주세요.");
                        return;
                      }
                      if (_selectedPlatform == null) {
                        Get.snackbar("알림", "플랫폼을 선택해주세요.");
                        return;
                      }
                      if (_webCheck && _webUrlController.text.isEmpty) {
                        Get.snackbar("알림", "Web Service URL을 입력해주세요.");
                        return;
                      }
                      if (_mobileCheck) {
                        if(_androidCheck && _androidUrlController.text.isEmpty){
                          Get.snackbar("알림", "Play Store URL을 입력해주세요.");
                          return;
                        }
                        if(_iosCheck && _iosUrlController.text.isEmpty){
                          Get.snackbar("알림", "App Store URL을 입력해주세요.");
                          return;
                        }
                      }
                      final domain = <String>[];
                      if (_webCheck) {
                        domain.add(_webUrlController.text);
                      } else {
                        if (_iosCheck) {
                          domain.add(_iosUrlController.text);
                        }
                        if (_androidCheck) {
                          domain.add(_androidUrlController.text);
                        }
                      }

                      List<ImageEntity> postImage = [];
                      final dir = await getTemporaryDirectory();

                      if (_selectedImages.isNotEmpty) {
                        postImage = await Future.wait(
                          _selectedImages.map((e) async {
                            final newPath = '${dir.path}/${path.basename(e.path)}';
                            final copiedFile = await File(e.path).copy(newPath);
                            return ImageEntity(
                              isLocal: true,
                              url: copiedFile.path, // 실제 존재하는 파일 경로
                            );
                          }),
                        );
                      }
                      if (widget.post != null) {
                        postImage.addAll(widget.post!.images!);
                      }
                      if (_deleteImages.isNotEmpty) {
                        postImage.removeWhere((element) => _deleteImages.contains(element));
                      }

                      final post = PromotionPostEntity(
                        title: _titleController.text,
                        subtitle: _subtitleController.text,
                        contents: _contentController.text,
                        category: _selectedCategory,
                        platform: _selectedPlatform,
                        mobileOs: _mobileCheck ? _selectedOs : null,
                        author: context.read<UserProvider>().user!,
                        domain: domain,
                        images: postImage,
                      );
                      Get.to(() => PromotionPostDetailPage(post: post));
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
                      if (_titleController.text.isEmpty ||
                          _subtitleController.text.isEmpty ||
                          _contentController.text.isEmpty) {
                        Get.snackbar("알림", "모든 항목을 입력해주세요.");
                        return;
                      }
                      if (_selectedPlatform == null) {
                        Get.snackbar("알림", "플랫폼을 선택해주세요.");
                        return;
                      }
                      if (_selectedImages.isEmpty) {
                        Get.snackbar("알림", "최소 한장의 이미지를 선택해주세요.");
                        return;
                      }
                      if (_webCheck && _webUrlController.text.isEmpty) {
                        Get.snackbar("알림", "Web Service URL을 입력해주세요.");
                        return;
                      }
                      if (_mobileCheck) {
                        if(_androidCheck && _androidUrlController.text.isEmpty){
                          Get.snackbar("알림", "Play Store URL을 입력해주세요.");
                          return;
                        }
                        if(_iosCheck && _iosUrlController.text.isEmpty){
                          Get.snackbar("알림", "App Store URL을 입력해주세요.");
                          return;
                        }
                      }
                      final domain = <String>[];
                      if (_webCheck) {
                        domain.add(_webUrlController.text);
                      } else {
                        if (_iosCheck) {
                          domain.add(_iosUrlController.text);
                        }
                        if (_androidCheck) {
                          domain.add(_androidUrlController.text);
                        }
                      }

                      try {
                        // context.read<RecruitPostBloc>().add(PostDataLoadEvent());
                        // final token = context.read<UserProvider>().token!;
                        final post = PromotionPostEntity(
                          title: _titleController.text,
                          subtitle: _subtitleController.text,
                          contents: _contentController.text,
                          category: _selectedCategory,
                          platform: _selectedPlatform,
                          mobileOs: _mobileCheck ? _selectedOs : null,
                          author: context.read<UserProvider>().user!,
                          domain: domain,
                          period: 7,
                        );
                        context.read<PromotionBloc>().add(RequestPostCreateEvent(token, post, _selectedImages));
                      } on Exception catch (e) {
                        logger.e(e);
                        Get.snackbar('알림', '등록 실패');
                        return;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: Text("등록"),
                  ),
                )
              else
                SizedBox(
                  height: 50,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_titleController.text.isEmpty ||
                          _subtitleController.text.isEmpty ||
                          _contentController.text.isEmpty) {
                        Get.snackbar("알림", "모든 항목을 입력해주세요.");
                        return;
                      }
                      if (_selectedPlatform == null) {
                        Get.snackbar("알림", "플랫폼을 선택해주세요.");
                        return;
                      }
                      if (_existedImages.isEmpty && _selectedImages.isEmpty) {
                        Get.snackbar("알림", "최소 한장의 이미지를 선택해주세요.");
                        return;
                      }
                      if (_webCheck && _webUrlController.text.isEmpty) {
                        Get.snackbar("알림", "Web Service URL을 입력해주세요.");
                        return;
                      }
                      if (_mobileCheck) {
                        if(_androidCheck && _androidUrlController.text.isEmpty){
                          Get.snackbar("알림", "Play Store URL을 입력해주세요.");
                          return;
                        }
                        if(_iosCheck && _iosUrlController.text.isEmpty){
                          Get.snackbar("알림", "App Store URL을 입력해주세요.");
                          return;
                        }
                      }
                      final domain = <String>[];
                      if (_webCheck) {
                        domain.add(_webUrlController.text);
                      } else {
                        if (_iosCheck) {
                          domain.add(_iosUrlController.text);
                        }
                        if (_androidCheck) {
                          domain.add(_androidUrlController.text);
                        }
                      }

                      try {

                        final post = PromotionPostEntity(
                            id: widget.post!.id,
                            title: _titleController.text,
                            subtitle: _subtitleController.text,
                            contents: _contentController.text,
                            category: _selectedCategory,
                            platform: _selectedPlatform,
                            mobileOs: _mobileCheck ? _selectedOs : null,
                            status: widget.post!.status,
                            period: widget.post!.period,
                            domain: domain,
                            author: context.read<UserProvider>().user!);
                        final token = context.read<UserProvider>().token ?? "";
                        context
                            .read<PromotionBloc>()
                            .add(RequestPostUpdateEvent(token, post, _selectedImages, _deleteImages));
                      } on Exception catch (e) {
                        logger.e(e);
                        Get.snackbar('알림', '수정 실패');
                      }

                      // Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: Text("수정하기"),
                  ),
                )
            ],
          ),
        ));
  }

  Widget _urlTextFiled(BuildContext context, String title, TextEditingController controller) {
    return SizedBox(
        height: 60,
        width: MediaQuery.sizeOf(context).width - 40,
        child: Column(children: [
          Row(
            children: [
              Flexible(
                flex: 2,
                child: SizedBox(
                    width: (MediaQuery.sizeOf(context).width - 40) * 0.2,
                    child: Text("$title : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
              ),
              Flexible(
                flex: 8,
                child: SizedBox(
                  height: 50,
                  width: (MediaQuery.sizeOf(context).width - 40) * 0.8,
                  child: TextField(
                    controller: controller,
                    // decoration: InputDecoration(enabled: false),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const Gap(10)
        ]));
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
                  Navigator.pop(context);
                  if (context.mounted) Navigator.pop(context);
                },
                child: Text("확인"))
          ],
        );
      },
    );
  }
}
