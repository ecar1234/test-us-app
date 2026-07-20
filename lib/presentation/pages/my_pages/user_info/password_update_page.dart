import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:test_us_app/data/models/user/user_model.dart';
import 'package:test_us_app/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:test_us_app/presentation/bloc/auth_bloc/auth_state.dart';
import 'package:test_us_app/presentation/components/alerts/one_button_alert.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';

import '../../../../services/common_height_provider.dart';
import '../../../bloc/auth_bloc/auth_event.dart';
import '../../main_page.dart';

class PasswordUpdatePage extends StatefulWidget {
  final String? email;
  const PasswordUpdatePage({super.key, this.email});

  @override
  State<PasswordUpdatePage> createState() => _PasswordUpdatePageState();
}

class _PasswordUpdatePageState extends State<PasswordUpdatePage> {

  final TextEditingController _oldPwController = TextEditingController();
  final TextEditingController _newPwController = TextEditingController();
  final TextEditingController _newPwCheckController = TextEditingController();
  bool isNewPwVisible = false;
  bool isNewPwCheckVisible = false;


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _oldPwController.dispose();
    _newPwController.dispose();
    _newPwCheckController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final hei = GetIt.I.get<ResponsiveHeightProvider>().hei ?? MediaQuery.sizeOf(context).height-120;
    // final hasPassword = context.read<UserProvider>().user!.method != AuthType.email && context.read<UserProvider>().user!.password != 'authUserRegister';
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('비밀번호 변경'),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
              if(state.state == UserAuthState.errorState){
                Get.snackbar('알림', state.message ?? '알 수 없는 문제로 비밀번호 변경에 실패했습니다.');
                return;
              }else if(state.state == UserAuthState.passwordUpdateCompletedState){
                await _completeDialog(context);
              }
            },
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // if(!widget.isOtp && hasPassword)
                  // SizedBox(
                  //   height: 60,
                  //   width: MediaQuery.sizeOf(context).width * 0.7,
                  //   child: TextField(
                  //     controller: _oldPwController,
                  //     obscureText: true,
                  //     maxLength: 20,
                  //     onChanged: (value) {
                  //       if(value.length > 20){
                  //         Get.snackbar('알림', '비밀호는 20자 이상 사용 할 수 없습니다.');
                  //       }
                  //     },
                  //     decoration: InputDecoration(
                  //       labelText: '기존 비밀번호',
                  //       counterText: '',
                  //     ),
                  //   ),
                  // ),
                  // const Gap(50),
                  Text(
                    "( 새 비밀번호는 8자 이상 / 영문, 숫자, 특수문자 포함 )",
                    style: TextStyle(fontSize: 14, color: Colors.blueAccent),
                  ),
                  const Gap(10),
                  // 신규 비빌번호
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 60,
                          child: TextField(
                            controller: _newPwController,
                            obscureText: true,
                            maxLength: 20,
                            onChanged: (value) {
                              setState(() {
                                isNewPwVisible = true;
                                if (value.isEmpty) {
                                  isNewPwVisible = false;
                                } else {
                                  isNewPwVisible = RegExp(
                                      r'^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$&*~]).{8,}$')
                                      .hasMatch(_newPwController.text);
                                }
                              });
                            },
                            decoration: InputDecoration(
                              labelText: '새 비밀번호',
                              counterText: '',
                            ),
                          ),
                        ),
                        if(isNewPwVisible && _newPwController.text.isNotEmpty)
                          SizedBox(
                              height: 20,
                              // width: MediaQuery.sizeOf(context).width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  isNewPwVisible
                                      ? SizedBox(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.green,
                                        size: 20,
                                      ))
                                      : SizedBox(
                                      child: Icon(
                                        Icons.cancel,
                                        color: Colors.redAccent,
                                        size: 20,
                                      )),
                                  const Gap(8),
                                  isNewPwVisible
                                      ? SizedBox(
                                    child: Text(
                                      "사용할 수 있는 비밀번호 입니다.",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  )
                                      : SizedBox(
                                    child: Text(
                                      "비밀번호 형식을 다시 확인해 주세요.",
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
                                  )
                                ],
                              ))
                        else
                          Gap(20)
                      ],
                    ),
                  ),
                  const Gap(20),
                  // 비밀번호 확인
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.7,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 60,
                          child: TextField(
                            controller: _newPwCheckController,
                            obscureText: true,
                            maxLength: 20,
                            onChanged: (value) {
                              setState(() {
                                isNewPwCheckVisible = true;
                                if (value.isEmpty) {
                                  isNewPwCheckVisible = false;
                                } else {
                                  isNewPwCheckVisible = _newPwController.text == _newPwCheckController.text;
                                }
                              });
                            },
                            decoration: InputDecoration(
                              labelText: '새 비밀번호 확인',
                              counterText: '',
                            ),
                          ),
                        ),
                        if(isNewPwCheckVisible && _newPwCheckController.text.isNotEmpty)
                          SizedBox(
                              height: 20,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  isNewPwCheckVisible
                                      ? SizedBox(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.green,
                                        size: 20,
                                      ))
                                      : SizedBox(
                                      child: Icon(
                                        Icons.cancel,
                                        color: Colors.redAccent,
                                        size: 20,
                                      )),
                                  const Gap(8),
                                  isNewPwCheckVisible
                                      ? SizedBox(
                                    child: Text(
                                      "비밀번호가 일치 합니다.",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  )
                                      : SizedBox(
                                    child: Text(
                                      "비밀번호 형식을 다시 확인해 주세요.",
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
                                  )
                                ],
                              ))
                        else
                         const Gap(20),
                      ],
                    ),
                  ),
                  const Gap(40),
                  SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.4,
                            height: 50,
                            child: ElevatedButton(onPressed: (){
                              // if(_oldPwController.text.isEmpty && !widget.isOtp){
                              //   Get.snackbar('알림', '기존 비밀번호를 입력해주세요.');
                              //   return;
                              // }
                              if(_newPwController.text.isEmpty) {
                                Get.snackbar('알림', '새 비밀번호를 입력해주세요.');
                                return;
                              }
                              if(_newPwCheckController.text.isEmpty){
                                Get.snackbar('알림', '새 비밀번호 확인을 입력해주세오.');
                                return;
                              }
                              if(!isNewPwVisible){
                                Get.snackbar('알림', '비밀번호 형식을 다시 확인해주세요.');
                                return;
                              }
                              if(!isNewPwCheckVisible){
                                Get.snackbar('알림', '비밀번호 확인이 일치하지 않습니다.');
                                return;
                              }

                              final token = context.read<UserProvider>().token ?? "";
                              final user = context.read<UserProvider>().user;
                              if(widget.email != null){
                                context.read<AuthBloc>()
                                    .add(PasswordChangeEvent(widget.email!, _newPwController.text));
                              }else {
                                context.read<AuthBloc>()
                                    .add(PasswordUpdateEvent(token, user!.id!, _newPwController.text));
                              }
                            }, style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.zero,
                            ), child: Text('비밀번호 변경')),
                          )
                        ],
                      )
                  )
                ],
              ),
            ),
          ),
        )
      )
    );
  }

  Future<void> _completeDialog(BuildContext context){
    return showDialog(context: context, builder: (context) =>
        OneButtonAlert(mainContent: '비밀번호 설정을 완료 했습니다.', buttonName: '확인', onPressed: (){
          Get.back();
          Get.back();
        }));
  }
}
