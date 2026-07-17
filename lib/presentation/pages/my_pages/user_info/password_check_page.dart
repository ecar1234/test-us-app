import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:test_us_app/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:test_us_app/presentation/components/alerts/one_button_alert.dart';
import 'package:test_us_app/presentation/pages/my_pages/user_info/password_update_page.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/services/common_height_provider.dart';

import '../../../bloc/auth_bloc/auth_event.dart';
import '../../../bloc/auth_bloc/auth_state.dart';
import '../../../bloc/user_bloc/user_bloc.dart';

class PasswordCheckPage extends StatefulWidget {
  const PasswordCheckPage({super.key});

  @override
  State<PasswordCheckPage> createState() => _PasswordCheckPageState();
}

class _PasswordCheckPageState extends State<PasswordCheckPage> {
  final TextEditingController _oldPwController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _oldPwController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wid = MediaQuery.sizeOf(context).width;
    return SafeArea(
        child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('비밀번호 변경'),
          ),
          body: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is PasswordCheckCompletedState) {
                if (state.isVerified) {
                  showDialog(context: context, builder: (context) =>
                      OneButtonAlert(
                        title: '인증 완료',
                          mainContent: '비밀번호 설정 페이지로 이동 합니다.',
                          buttonName: '확인',
                          onPressed: (){
                            Get.back();
                            Get.off(() => PasswordUpdatePage());
                            return;
                          }));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('기존 비밀번호가 일치하지 않습니다.'),
                    duration: Duration(milliseconds: 800),
                  ));
                }
              }
            },
            child: Center(
              child: SizedBox(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text('비밀번호 확인', style: TextStyle(
                          //   fontSize: 18,
                          //   fontWeight: FontWeight.bold
                          // ),),
                          // const Gap(10),
                          SizedBox(
                              height: 50,
                              width: wid * 0.6,
                              child: TextField(
                                controller: _oldPwController,
                                obscureText: true,
                                maxLength: 20,
                                decoration: InputDecoration(
                                  counterText: '',
                                  labelText: '기존 비밀번호',
                                ),
                              )),
                        ],
                      ),
                      const Gap(40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                            width: wid * 0.3,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_oldPwController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text('비밀번호를 입력해주세요'),
                                    duration: Duration(milliseconds: 800),
                                  ));
                                  return;
                                }
                                final userId = context.read<UserProvider>().user?.id ?? '';
                                final token = context.read<UserProvider>().token ?? '';
                                if (userId.isEmpty || token.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text('유저 정보를 찾을 수 없습니다.'),
                                    duration: Duration(milliseconds: 800),
                                  ));
                                  return;
                                }
                                context.read<AuthBloc>().add(VerifyPasswordEvent(token, userId, _oldPwController.text));
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                              child: Text('확인'),
                            ),
                          ),
                        ],
                      )
                    ]),
              ),
            ),
          )),
    ));
  }
}
