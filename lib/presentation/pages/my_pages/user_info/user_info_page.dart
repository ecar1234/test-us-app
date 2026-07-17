import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';
import 'package:test_us_app/presentation/bloc/user_bloc/user_event.dart';
import 'package:test_us_app/presentation/bloc/user_bloc/user_state.dart';
import 'package:test_us_app/presentation/components/alerts/one_button_alert.dart';
import 'package:test_us_app/presentation/pages/my_pages/user_info/password_check_page.dart';
import 'package:test_us_app/presentation/pages/my_pages/user_info/password_update_page.dart';
import 'package:test_us_app/presentation/pages/my_pages/user_info/user_delete_page.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:test_us_app/utils/type_conversion_util.dart';

import '../../../../data/models/user/user_model.dart';
import '../../../provider/purchase_provider.dart';
import '../../../../services/theme_provider.dart';
import '../../../bloc/user_bloc/user_bloc.dart';
import '../../../provider/post_provider/base_post_provider.dart';

class UserInfoPage extends StatefulWidget {
  final UserEntity user;

  const UserInfoPage({super.key, required this.user});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final _nicknameController = TextEditingController();
  final _userTypeController = TextEditingController();
  final _userRoleController = TextEditingController();
  XFile? _selectProfileImage;
  final ImagePicker _picker = ImagePicker();
  final typeUtil = TypeConversionUtil();

  bool _isPicks = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nicknameController.text = widget.user.nickname!;
    // _userTypeController.text = _userTypeToString(widget.user.userType!);
    // _userRoleController.text = _userRoleToString(widget.user.role!);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nicknameController.dispose();
    _userTypeController.dispose();
    _userRoleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei ?? 0;
    final wid = MediaQuery.sizeOf(context).width - 40;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('내 정보'),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: BlocListener<UserBloc, UserState>(
            listener: (context, state) async {
              if (state.state == UserDataState.userInfoUpdateCompletedState) {
                await showDialog(
                    context: context,
                    builder: (context) => OneButtonAlert(
                        title: '업데이트',
                        mainContent: '업데이트 진행 완료.',
                        buttonName: '확인',
                        onPressed: () {
                          context.read<UserProvider>().updateUserInfo(state.user!);
                          context.read<BasePostProvider>().userInfoUpdate(state.user!);
                          Get.back();
                          Get.back();
                        }));
              }
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    _profileSection(context, hei, wid),
                    const Gap(20),
                    _emailSection(context, wid),
                    const Gap(20),
                    _nicknameSection(context, wid),
                    const Gap(20),
                    _userTypeSection(context, wid),
                    const Gap(20),
                    _userRoleSection(context, wid),
                    const Gap(30),
                    _buttonSection(context, wid),
                    const Gap(30),
                    _userInfoButtonSection(context, wid)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileSection(BuildContext context, double hei, double wid) {
    // final activePlan = context.read<PurchasesManagements>().subscribedItem;
    // final volumeLimit = activePlan == null ? 6 : (activePlan.plan == 'standard' ? 7 : 10);
    final volumeLimit = 5;

    return SizedBox(
        height: hei * 0.25,
        width: wid,
        child: SizedBox(
          width: wid,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: _selectProfileImage != null
                          ? FileImage(File(_selectProfileImage!.path))
                          : (widget.user.profileImg == null || widget.user.profileImg!.url == null
                              ? const AssetImage('assets/images/Generic avatar.png')
                              : CachedNetworkImageProvider(widget.user.profileImg!.url!)) as ImageProvider,
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {
                          if (_isPicks) return;

                          setState(() {
                            _isPicks = true; // 잠금장치 ON
                          });

                          try {
                            final image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
                            if (image == null) {
                              return;
                            } else if (File(image.path).lengthSync() / (1024 * 1024) > volumeLimit) {
                              Get.snackbar('알림', '${volumeLimit}MB를 초과하는 이미지는 업로드 할 수 없습니다.');
                              return;
                            } else {
                              setState(() {
                                _selectProfileImage = image;
                              });
                            }
                          } finally {
                            if (mounted) {
                              setState(() {
                                _isPicks = false; // 잠금장치 off
                              });
                            }
                          }
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              border: Border.all(color: Colors.grey),
                              shape: BoxShape.circle),
                          child: Icon(
                            Icons.camera_alt,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ))
                ],
              )
            ],
          ),
        ));
  }

  Widget _emailSection(BuildContext context, double wid) {
    return SizedBox(
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
        Flexible(
            flex: 2,
            child: SizedBox(
                width: wid * 0.2,
                child: Text(
                  '이메일',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ))),
        const Gap(10),
        Flexible(
            flex: 8, child: SizedBox(width: wid * 0.8, child: Text(widget.user.email!, style: TextStyle(fontSize: 18))))
      ]),
    );
  }

  Widget _nicknameSection(BuildContext context, double wid) {
    return SizedBox(
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
        Flexible(
            flex: 2,
            child: SizedBox(
                width: wid * 0.2, child: Text('닉네임', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)))),
        Flexible(
          flex: 8,
          child: SizedBox(
              height: 60,
              width: wid * 0.8,
              child: TextField(
                controller: _nicknameController,
              )),
        )
      ]),
    );
  }

  Widget _userTypeSection(BuildContext context, double wid) {
    return SizedBox(
      child: Row(children: [
        Flexible(
            flex: 2,
            child: SizedBox(
              width: wid * 0.2,
              child: Text('유져 타입', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            )),
        Flexible(
            flex: 8,
            child: SizedBox(
              child: DropdownMenu(
                  controller: _userTypeController,
                  menuHeight: 300,
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  initialSelection: typeUtil.userTypeToString(widget.user.userType!),
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: "", label: "선택"),
                    DropdownMenuEntry(value: "INDIVIDUALS", label: "1인 개발자"),
                    DropdownMenuEntry(value: "COMPANIES", label: "기업"),
                  ]),
            ))
      ]),
    );
  }

  Widget _userRoleSection(BuildContext context, double wid) {
    return SizedBox(
      child: Row(children: [
        Flexible(
            flex: 2,
            child: SizedBox(
              width: wid * 0.2,
              child: Text('역할', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            )),
        Flexible(
            flex: 8,
            child: SizedBox(
              height: 60,
              width: wid * 0.8,
              child: DropdownMenu(
                  controller: _userRoleController,
                  menuHeight: 300,
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  initialSelection: typeUtil.userRoleToString(widget.user.role!),
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: "", label: "선택"),
                    DropdownMenuEntry(value: "programmer", label: "프로그래머"),
                    DropdownMenuEntry(value: "planner", label: "기획자"),
                    DropdownMenuEntry(value: "marketer", label: "마케터"),
                    DropdownMenuEntry(value: "designer", label: "디자이너"),
                    DropdownMenuEntry(value: "publisher", label: "퍼블리셔"),
                    DropdownMenuEntry(value: "analyst", label: "데이터 분석"),
                    DropdownMenuEntry(value: "operator", label: "서비스 운영"),
                    DropdownMenuEntry(value: "pm", label: "PM"),
                    DropdownMenuEntry(value: "qa", label: "QA"),
                    DropdownMenuEntry(value: "cs", label: "CS"),
                  ]),
            ))
      ]),
    );
  }

  Widget _buttonSection(BuildContext context, double wid) {
    return SizedBox(
        height: 50,
        width: wid,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: wid * 0.2,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('확인')),
            ),
            const Gap(20),
            BlocSelector<UserBloc, UserState, bool>(
                selector: (state) => state.state == UserDataState.loadingState,
                builder: (context, isLoading) {
                  return SizedBox(
                    width: wid * 0.6,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (isLoading) {
                            Get.snackbar('알림', '업데이트 중입니다.');
                            return;
                          }
                          final token = context.read<UserProvider>().token ?? '';
                          final userInfo = UserEntity(
                            id: widget.user.id,
                            email: widget.user.email,
                            nickname: _nicknameController.text,
                            userType: typeUtil.toUserType(_userTypeController.text),
                            role: typeUtil.toUserRole(_userRoleController.text),
                            profileImg: widget.user.profileImg,
                          );

                          if (_selectProfileImage != null) {
                            context.read<UserBloc>().add(RequestUserInfoUpdateEvent(token, userInfo,
                                profileImage: _selectProfileImage, oldImage: widget.user.profileImg));
                          } else {
                            if (widget.user.profileImg != null) {
                              userInfo.profileImg = widget.user.profileImg;
                            }
                            final checkNickname =
                                await context.read<UserProvider>().isNicknameAvailable(_nicknameController.text);
                            if (checkNickname && context.mounted) {
                              context.read<UserBloc>().add(RequestUserInfoUpdateEvent(token, userInfo));
                            } else {
                              Get.snackbar('알림', '이미 존재하는 닉네임입니다.');
                              return;
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: isLoading ? CircularProgressIndicator() : Text('업데이트')),
                  );
                }),
          ],
        ));
  }

  Widget _userInfoButtonSection(BuildContext context, double wid) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    return Container(
        width: wid,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            // border: Border.all(),
            borderRadius: BorderRadius.circular(10),
            color: isDarkMode ? Colors.grey.shade800 : Colors.white,
            boxShadow: isDarkMode
                ? null
                : [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]),
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (widget.user.method != AuthType.email) {
                  Get.snackbar('알림', '이메일 로그인만 가능합니다.');
                  return;
                }
                Get.to(() => PasswordCheckPage());
                return;
              },
              child: SizedBox(
                height: 40,
                width: wid - 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "비밀번호 변경",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Icon(Icons.arrow_forward_ios_sharp, size: 16)
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey.shade200,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                // Get.to(() => UserDeletePage());
              },
              child: SizedBox(
                height: 40,
                width: wid - 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "구매 내역 관리",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Icon(Icons.arrow_forward_ios_sharp, size: 16)
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey.shade200,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Get.to(() => UserDeletePage());
              },
              child: SizedBox(
                height: 40,
                width: wid - 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "회원 탈퇴",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Icon(Icons.arrow_forward_ios_sharp, size: 16)
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
