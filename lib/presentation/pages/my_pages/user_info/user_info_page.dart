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
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:test_us_app/utils/type_conversion_util.dart';

import '../../../../data/models/user/user_model.dart';
import '../../../bloc/user_bloc/user_bloc.dart';

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
  XFile? profileImage;
  final ImagePicker _picker = ImagePicker();
  final typeUtil = TypeConversionUtil();


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
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if(state.state == UserDataState.getUsersInfoCompletedState){
                context.read<UserProvider>().updateUserInfo(state.user!);
                Get.back();
              }
            },
            child: SingleChildScrollView(
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileSection(BuildContext context,double hei, double wid) {
    return SizedBox(
      height: hei * 0.3,
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
                    backgroundImage:  profileImage != null

                        ? FileImage(File(profileImage!.path))
                        : (widget.user.profileImg == null || widget.user.profileImg!.url == null
                        ? const AssetImage('assets/images/Generic avatar.png')
                    // 2-2. 기존 네트워크 이미지가 있으면 CachedNetworkImageProvider로 표시
                        : CachedNetworkImageProvider(widget.user.profileImg!.url!))
                    as ImageProvider,
                  ),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () async {
                        final image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
                        if (image == null) {
                          return;
                        } else if (File(image.path).lengthSync() / (1024 * 1024) > 5) {
                          Get.snackbar('알림', '5MB를 초과하는 이미지는 업로드 할 수 없습니다.');
                          return;
                        } else {
                          setState(() {
                            profileImage = image;
                          });
                        }
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                            border: Border.all(color: Colors.grey),
                            shape: BoxShape.circle
                        ),
                        child: Icon(Icons.camera_alt, color: Colors.black54,),
                      ),
                    )
                )
              ],
            )
          ],
        ),
      )
    );
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54),
                ))),
        const Gap(10),
        Flexible(
            flex: 8,
            child: SizedBox(
                width: wid * 0.8,
                child: Text(widget.user.email!, style: TextStyle(fontSize: 18, color: Colors.black54))))
      ]),
    );
  }

  Widget _nicknameSection(BuildContext context, double wid) {
    return SizedBox(
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
        Flexible(
            flex: 2,
            child: SizedBox(
                width: wid * 0.2,
                child:
                    Text('닉네임', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54)))),
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
              child: Text('유져 타입', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black54)),
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
              child: Text('역할', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black54)),
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
                    DropdownMenuEntry(
                        value: "programmer", label: "프로그래머"),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('확인')
            ),
          ),
          const Gap(20),
          SizedBox(
            width: wid * 0.6,
            height: 50,
            child: ElevatedButton(
                onPressed: () {
                  final token = context.read<UserProvider>().token ?? '';
                  final userInfo = UserEntity(
                    id: widget.user.id,
                    email: widget.user.email,
                    nickname: _nicknameController.text,
                    userType: typeUtil.toUserType(_userTypeController.text),
                    role: typeUtil.toUserRole(_userRoleController.text),
                  );

                  if(profileImage != null) {
                    context.read<UserBloc>()
                        .add(RequestUserInfoUpdateEvent(token, userInfo, profileImage: profileImage, oldImage: widget.user.profileImg));
                  }else {
                    if(widget.user.profileImg != null){
                      userInfo.profileImg = widget.user.profileImg;
                    }
                    context.read<UserBloc>().add(RequestUserInfoUpdateEvent(token, userInfo));
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('업데이트')
            ),
          ),
        ],
      )
    );
  }
}
