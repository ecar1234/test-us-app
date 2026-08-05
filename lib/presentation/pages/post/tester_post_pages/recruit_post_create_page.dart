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
import 'package:test_us_app/data/models/post/recruit_post_model.dart';
import 'package:test_us_app/data/models/user/user_model.dart';
import 'package:test_us_app/domain/entities/purchase_entity.dart';

import 'package:test_us_app/domain/entities/recruit_post_entity.dart';
import 'package:test_us_app/presentation/bloc/user_bloc/user_state.dart';
import 'package:test_us_app/presentation/components/alerts/one_button_alert.dart';
import 'package:test_us_app/presentation/pages/post/tester_post_pages/recruit_post_detail_page.dart';
import 'package:test_us_app/presentation/provider/post_provider/base_post_provider.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:test_us_app/presentation/provider/purchase_provider.dart';
import 'package:test_us_app/utils/type_conversion_util.dart';

import '../../../../data/models/application/application_model.dart';
import '../../../../domain/entities/image_entity.dart';
import '../../../bloc/post_blocs/recruit_post_bloc/recruit_post_bloc.dart';
import '../../../bloc/post_blocs/recruit_post_bloc/recruit_post_event.dart';
import '../../../bloc/post_blocs/recruit_post_bloc/recruit_post_state.dart';
import '../../../bloc/user_bloc/user_bloc.dart';
import '../../../provider/post_provider/recruit_post_provider.dart';

class RecruitPostCreatePage extends StatefulWidget {
  final RecruitPostEntity? post;

  const RecruitPostCreatePage({super.key, this.post});

  @override
  State<RecruitPostCreatePage> createState() => _RecruitPostCreatePageState();
}

class _RecruitPostCreatePageState extends State<RecruitPostCreatePage> {
  final logger = Logger();
  final picker = ImagePicker();
  List<XFile> _selectedImages = [];
  List<ImageEntity> _existedImages = [];
  final List<ImageEntity> _deleteImages = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _periodController = TextEditingController();

  // final GlobalKey<TooltipState> tooltipKey = GlobalKey<TooltipState>();

  ApplicationPlatform? _selectedPlatform;
  MobileOsType? _selectedOs;
  PostCategory? _selectedCategory = PostCategory.game;

  bool _webCheck = false;
  bool _mobileCheck = false;
  bool _iosCheck = false;
  bool _androidCheck = false;

  @override
  void initState() {
    super.initState();
    if (widget.post != null) {
      _titleController.text = widget.post!.title!;
      _subtitleController.text = widget.post!.subtitle!;
      _contentController.text = widget.post!.contents!;
      _selectedPlatform = widget.post!.platform!;
      _selectedOs = widget.post!.mobileOs;
      _selectedCategory = widget.post!.category;
      _periodController.text = widget.post!.period.toString();
      if (widget.post!.images != null && widget.post!.images!.isNotEmpty) {
        _existedImages = widget.post!.images!;
      }
      if (_selectedPlatform == ApplicationPlatform.web) {
        _webCheck = true;
      }
      if (_selectedPlatform == ApplicationPlatform.mobile) {
        _mobileCheck = true;
        if (_selectedOs == MobileOsType.ios) {
          _iosCheck = true;
        }
        if (_selectedOs == MobileOsType.android) {
          _androidCheck = true;
        }
      }
    }
  }

  @override
  void didUpdateWidget(covariant RecruitPostCreatePage oldWidget) {
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
  }

  // void _onPlatformSelected(bool? checked, String platform) {
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    // final activePlan = context.read<PurchasesManagements>().subscribedItem;
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
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
                      // 플랫폼
                      _platformSection(),
                      const Gap(20),
                      if (_mobileCheck) _mobileOsSection(),
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
            ),
          )
        ],
      ),
    );
  }

  Widget _addImageSection() {
    // final imagesLimit = activePlan == null ? 4 : (activePlan.plan == 'standard' ? 6 : 8);
    // final volumeLimit = activePlan == null ? 6 : (activePlan.plan == 'standard' ? 7 : 10);
    final imagesLimit = 4;
    final volumeLimit = 5;
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
                  "서비스 이미지 추가 (${_existedImages.length + _selectedImages.length} / $imagesLimit)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )),
                SizedBox(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                      // TODO: 이미지 추가 버튼을 왜 나눠야 하는가? 단순 limit만 활용해도 하나로 만들 수 있는지 테스트 필요.
                      onPressed: _existedImages.length == imagesLimit - 1
                          ? () async {
                              final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
                              if (image == null) {
                                return;
                              } else if (File(image.path).lengthSync() / (1024 * 1024) > volumeLimit) {
                                Get.snackbar('알림', '${volumeLimit}Mb를 초과하는 이미지는 업로드 할 수 없습니다.');
                                return;
                              } else if (_existedImages.length + _selectedImages.length >= imagesLimit) {
                                Get.snackbar('알림', '최대 $imagesLimit개의 이미지를 선택할 수 있습니다.');
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
                                      limit:
                                          _existedImages.isNotEmpty ? imagesLimit - _existedImages.length : imagesLimit)
                                  .onError((e, state) {
                                Get.snackbar('알림', '이미지 선택에 실패했습니다.');
                                return [];
                              });
                              if (images.isEmpty) {
                                return;
                              } else if (images.length + _existedImages.length > imagesLimit) {
                                Get.snackbar('알림', '최대 $imagesLimit개의 이미지를 선택할 수 있습니다.');
                                return;
                              } else {
                                final sizeList = images.map((e) => File(e.path).lengthSync() / (1024 * 1024)).toList();
                                if (sizeList.any((element) => element > volumeLimit)) {
                                  Get.snackbar('알림', '${volumeLimit}MB를 초과하는 이미지는 업로드 할 수 없습니다.');
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
                                          color: Colors.black.withAlpha(124),
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
                      itemCount: _selectedImages.length + _existedImages.length,
                    ))
        ],
      ),
    );
  }

  Widget _periodSection() {
    // final period = activePlan == null ? 7 : (activePlan.plan == 'standard' ? 14 : 30);
    final period = 14;
    return SizedBox(
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
                      width: 150,
                      child: DropdownMenu(
                          controller: _periodController,
                          initialSelection: period,
                          onSelected: (int? value) {
                            setState(() {
                              _periodController.text = value.toString();
                            });
                          },
                          menuHeight: 200,
                          textAlign: TextAlign.end,
                          dropdownMenuEntries: List.generate(period, (index) {
                            return DropdownMenuEntry(
                              value: index + 1,
                              label: (index + 1).toString(),
                            );
                          }))),
                  const Gap(10),
                  SizedBox(child: Text("일", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
                ],
              ),
            )
          ],
        ));
  }

  Widget _platformSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
          width: MediaQuery.sizeOf(context).width - 40,
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: SizedBox(
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
                  ),
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      height: 30,
                      child: Row(
                        children: [
                          Checkbox(
                              value: _mobileCheck,
                              onChanged: (value) async {
                                setState(() {
                                  _mobileCheck = value!;
                                  _selectedPlatform = ApplicationPlatform.mobile;
                                  if (value == true) {
                                    _webCheck = false;
                                  }
                                });
                                if (value == true) {
                                  // await showModalBottomSheet(
                                  //     context: context,
                                  //     isDismissible: false,
                                  //     builder: (context) {
                                  //       return _mobileOsSection();
                                  //     });
                                } else {
                                  setState(() {
                                    _selectedOs = null;
                                    _androidCheck = false;
                                    _iosCheck = false;
                                  });
                                }
                              }),
                          Text(
                            'Mobile Service',
                            style:
                                TextStyle(fontSize: 14, fontWeight: _mobileCheck ? FontWeight.bold : FontWeight.normal),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }

  Widget _mobileOsSection() {
    return Container(
      width: MediaQuery.sizeOf(context).width - 40,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              child: Text(
            "모바일 OS",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )),
          const Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Checkbox(
                          value: _androidCheck,
                          onChanged: (value) {
                            setState(() {
                              _androidCheck = value!;
                              if (value) {
                                _iosCheck = false;
                                _selectedOs = MobileOsType.android;
                              }
                            });
                          }),
                      Text(
                        'Android OS',
                        style: TextStyle(fontSize: 14, fontWeight: _androidCheck ? FontWeight.bold : FontWeight.normal),
                      )
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      Checkbox(
                          value: _iosCheck,
                          onChanged: (value) {
                            setState(() {
                              _iosCheck = value!;
                              if (value) {
                                _androidCheck = false;
                                _selectedOs = MobileOsType.ios;
                              }
                            });
                          }),
                      Text(
                        'IOS',
                        style: TextStyle(fontSize: 14, fontWeight: _iosCheck ? FontWeight.bold : FontWeight.normal),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
            )),
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
                    dropdownMenuEntries: List.generate(PostCategory.values.length, (index) {
                      return DropdownMenuEntry(
                        value: PostCategory.values[index],
                        label: TypeConversionUtil().postCategoryToString(PostCategory.values[index]),
                      );
                    })))
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
    return BlocListener<RecruitPostBloc, RecruitPostState>(
        listener: (context, state) async {
          final provider = context.read<BasePostProvider>();
          if (state.state == RecruitPostLoadState.postCreateCompletedState) {
            provider.createRecruitPost(state.post!);
            await showDialog(
              context: context,
              builder: (context) => OneButtonAlert(
                  title: '알림',
                  mainContent: '테스터 모집글을 게시 했습니다.',
                  buttonName: '확인',
                  onPressed: () {
                    Navigator.pop(context);
                    if (context.mounted) Navigator.pop(context);
                  }),
            );
          } else if (state.state == RecruitPostLoadState.postUpdateCompletedState) {
            provider.updateRecruitPost(state.post!);
            provider.updateUserRecruitPosts(state.post!);
            await showDialog(
              context: context,
              builder: (context) => OneButtonAlert(
                  title: '알림',
                  mainContent: '테스터 모집글을 수정 했습니다.',
                  buttonName: '확인',
                  onPressed: () {
                    Navigator.pop(context);
                    if (context.mounted) Navigator.pop(context);
                  }),
            );
          } else if (state.state == RecruitPostLoadState.errorState ||
              state.state == RecruitPostLoadState.failedState) {
            Get.snackbar('알림', '등록 실패');
            return;
          }
        },
        child: SizedBox(
          height: 50,
          width: MediaQuery.sizeOf(context).width - 40,
          child: BlocSelector<RecruitPostBloc, RecruitPostState, bool>(
            selector: (state) => state.state == RecruitPostLoadState.dataLoadState,
            builder: (context, isLoading) => Row(
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
                          Get.snackbar("알림", "플랫폼 선택해주세요.");
                          return;
                        }

                        if (_selectedCategory == null) {
                          Get.snackbar("알림", "카테고리를 선택해주세요.");
                          return;
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

                        if (context.mounted) {
                          final user = context.read<UserProvider>().user!;
                          user.status = UserStatus.active;
                          final post = RecruitPostEntity(
                            title: _titleController.text,
                            subtitle: _subtitleController.text,
                            contents: _contentController.text,
                            platform: _selectedPlatform,
                            category: _selectedCategory,
                            mobileOs: _mobileCheck ? _selectedOs : null,
                            author: user,
                            images: postImage,
                          );
                          Get.to(() => RecruitPostDetailPage(post: post));
                        }
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
                        if (isLoading) {
                          Get.snackbar("알림", "잠시만 기다려주세요.");
                          return;
                        }
                        if (_titleController.text.isEmpty ||
                            _subtitleController.text.isEmpty ||
                            _contentController.text.isEmpty) {
                          Get.snackbar("알림", "모든 항목을 입력해주세요.");
                          return;
                        }
                        if (_selectedCategory == null) {
                          Get.snackbar("알림", "플랫폼을 선택해주세요.");
                          return;
                        }
                        if (_selectedImages.isEmpty) {
                          Get.snackbar("알림", "최소 한장의 이미지를 선택해주세요.");
                          return;
                        }
                        try {
                          final post = RecruitPostEntity(
                            title: _titleController.text,
                            subtitle: _subtitleController.text,
                            contents: _contentController.text,
                            platform: _selectedPlatform,
                            category: _selectedCategory,
                            mobileOs: _mobileCheck ? _selectedOs : null,
                            author: context.read<UserProvider>().user!,
                            period: 7,
                          );
                          context.read<RecruitPostBloc>().add(RequestPostCreateEvent(token, post, _selectedImages));
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
                        if (isLoading) {
                          Get.snackbar("알림", "잠시만 기다려주세요.");
                          return;
                        }
                        final post = RecruitPostEntity(
                            id: widget.post!.id,
                            title: _titleController.text,
                            subtitle: _subtitleController.text,
                            contents: _contentController.text,
                            platform: _selectedPlatform,
                            category: _selectedCategory,
                            mobileOs: _mobileCheck ? _selectedOs : null,
                            status: widget.post!.status,
                            period: int.parse(_periodController.text),
                            author: context.read<UserProvider>().user!);
                        final token = context.read<UserProvider>().token ?? "";
                        try {
                          context
                              .read<RecruitPostBloc>()
                              .add(RequestPostUpdateEvent(token, post, _selectedImages, _deleteImages));
                        } on Exception catch (e) {
                          logger.e(e);
                          Get.snackbar('알림', '수정 실패');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      child: Text("수정하기"),
                    ),
                  )
              ],
            ),
          ),
        ));
  }

  Future<void> _alertDialog(BuildContext context, String content) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("게시 성공"),
          content: Text("테스터 모집글을 $content 했습니다."),
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
