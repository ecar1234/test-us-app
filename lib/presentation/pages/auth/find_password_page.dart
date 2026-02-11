import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:test_us_app/presentation/bloc/auth_bloc/auth_event.dart';
import 'package:test_us_app/presentation/bloc/auth_bloc/auth_state.dart';
import 'package:test_us_app/presentation/pages/my_pages/user_info/password_update_page.dart';
import 'package:test_us_app/utils/time_util.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';

class FindPasswordPage extends StatefulWidget {
  const FindPasswordPage({super.key});

  @override
  State<FindPasswordPage> createState() => _FindPasswordPageState();
}

class _FindPasswordPageState extends State<FindPasswordPage> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _timerStart = false;
  bool _isCodeValid = false;
  bool _timerOver = false;
  Stream<int>? _timerStream;

  void _startTimer() {
    setState(() {
      _timerStart = true;
      _timerOver = false;
      _timerStream = Stream.periodic(const Duration(seconds: 1), (i) => 179 - i).take(180).asBroadcastStream();
    });
    _timerStream!.listen((event) {
      if (event <= 0) {
        setState(() {
          _isCodeValid = false;
          _timerOver = true;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _codeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is FindPasswordCompletedState) {
            _startTimer();
          } else if(state is VerifyOtpCompletedState) {
            setState(() {
              _isCodeValid = true;
            });
          }else if (state.state == UserAuthState.failedState) {
            Get.snackbar('알림', state.message!);
            return;
          } else if (state.state == UserAuthState.errorState) {
            Get.snackbar('알림', state.message!);
            return;
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery
                    .sizeOf(context)
                    .width * 0.7,
                child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "이메일",
                    )),
              ),
              const Gap(20),
              if (_timerStart)
                ...[ Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery
                          .sizeOf(context)
                          .width * 0.3,
                      child: TextField(controller: _codeController, decoration: InputDecoration(hintText: '인증번호')),
                    ),
                    const Gap(10),
                    StreamBuilder(
                        stream: _timerStream,
                        builder: (context, snapshot) {
                          if (_timerStream == null || !snapshot.hasData) {
                            return Text("03:00", style: const TextStyle(fontSize: 14));
                          }

                          final seconds = snapshot.data!;
                          if (seconds <= 0) {
                            return const Text(
                              "시간 종료",
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            );
                          }

                          return Text(
                            TimeUtil().toMMSS(seconds), // 위에서 만든 Extension 사용
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFeatures: [FontFeature.tabularFigures()], // 숫자 너비를 일정하게 고정 (깜빡임 방지)
                            ),
                          );
                        }),
                    const Gap(10),
                    SizedBox(
                      child: ElevatedButton(onPressed: _timerOver ? null : () {
                        if(_codeController.text.isEmpty){
                          Get.snackbar('알림', '인증번호는 빈 값으로 설정할 수 없습니다.');
                          return;
                        }
                        context.read<AuthBloc>().add(VerifyOtpEvent(_emailController.text, _codeController.text));
                      }, child: Text('인증')),
                    )
                  ],
                ),
                  const Gap(20),
                ],
              if(_isCodeValid)
                SizedBox(
                  width: MediaQuery
                      .sizeOf(context)
                      .width * 0.5,
                  height: 50,
                  child: ElevatedButton(onPressed: () {
                    Get.to(() => PasswordUpdatePage(isOtp: true, email: _emailController.text,));
                  }, style: ElevatedButton.styleFrom(
                    backgroundColor: Theme
                        .of(context)
                        .primaryColor,
                    foregroundColor: Colors.white,
                  ),child: Text('비밀번호 변경')),
                )
              else
              SizedBox(
                width: MediaQuery
                    .sizeOf(context)
                    .width * 0.5,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      if (_emailController.text.isEmpty) {
                        Get.snackbar('알림', '이메일은 빈 값으로 설정할 수 없습니다.');
                        return;
                      }
                      context.read<AuthBloc>().add(FindPasswordEvent(_emailController.text));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme
                          .of(context)
                          .primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('인증번호 받기')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
