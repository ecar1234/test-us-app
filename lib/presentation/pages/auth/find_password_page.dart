import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:test_us_app/presentation/bloc/auth_bloc/auth_event.dart';
import 'package:test_us_app/presentation/bloc/auth_bloc/auth_state.dart';
import 'package:test_us_app/presentation/components/alerts/one_button_alert.dart';
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
  bool _timerCenceled = false;
  bool _timerOver = false;
  bool _isCodeValid = false;
  StreamSubscription<int>? _timerStream;
  int _currentSeconds = 179;

  void _startTimer() {
    _timerStream?.cancel();
    _timerStream = Stream.periodic(const Duration(seconds: 1), (i) => 179 - i).take(180).listen((seconds) {
      setState(() {
        _currentSeconds = seconds;
      });

      // 0초가 되면 자동으로 타이머 종료 처리
      if (_currentSeconds <= 0) {
        _stopTimer();
        _timerOver = true;
      }
    });
  }

  void _stopTimer() {
    setState(() {
      // .cancel()을 호출하면 그 즉시 스트림의 동작이 멈추고 스트림 자체가 제거됩니다.
      _timerStream?.cancel();
      _timerStream = null; // 완전히 초기화
      _timerCenceled = true;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _codeController.dispose();
    _timerStream?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = _currentSeconds ~/ 60;
    int seconds = _currentSeconds % 60;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is FindPasswordCompletedState) {
            _timerStart = true;
            _startTimer();
            showDialog(
                context: context,
                builder: (context) => OneButtonAlert(
                    height: 200,
                    title: '알림',
                    mainContent: '요청하신 이메일로',
                    subContent: '인증번호가 발송되었습니다.',
                    buttonName: '확인',
                    onPressed: () {
                      Get.back();
                    }));
            return;
          } else if (state is VerifyOtpCompletedState) {
            setState(() {
              _isCodeValid = true;
              _timerCenceled = true;
            });
            _stopTimer();
            showDialog(
                context: context,
                builder: (context) => OneButtonAlert(
                    height: 200,
                    title: '인증 완료',
                    mainContent: '새 비밀번호를 설정해 주세요.',
                    buttonName: '확인',
                    onPressed: () {
                      Get.back();
                    }));
            return;
          } else if (state.state == UserAuthState.failedState) {
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
                width: MediaQuery.sizeOf(context).width * 0.7,
                child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "이메일",
                    )),
              ),
              const Gap(20),
              if (_timerStart) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.3,
                      child: TextField(controller: _codeController, decoration: InputDecoration(hintText: '인증번호')),
                    ),
                    const Gap(10),
                    Text(
                      _timerOver || _timerCenceled ? '0:00' : '$minutes:${seconds.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Gap(10),
                    if (!_timerOver)
                      SizedBox(
                        child: ElevatedButton(
                            onPressed: _timerCenceled
                                ? null
                                : () {
                                    if (_codeController.text.isEmpty) {
                                      Get.snackbar('알림', '인증번호는 빈 값으로 설정할 수 없습니다.');
                                      return;
                                    }
                                    context
                                        .read<AuthBloc>()
                                        .add(VerifyOtpEvent(_emailController.text, _codeController.text));
                                  },
                            child: Text('인증')),
                      )
                    else
                      SizedBox(
                        child: ElevatedButton(
                            onPressed: () {
                              if (_codeController.text.isEmpty) {
                                Get.snackbar('알림', '인증번호는 빈 값으로 설정할 수 없습니다.');
                                return;
                              }
                              context.read<AuthBloc>().add(FindPasswordEvent(_emailController.text));
                            },
                            child: Text('재 인증요청')),
                      )
                  ],
                ),
                const Gap(20),
              ],
              if (_timerStart)
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.5,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: _isCodeValid
                          ? () {
                              Get.off(() => PasswordUpdatePage(email: _emailController.text));
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('새 비밀번호 설정')),
                )
              else
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.5,
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
                        backgroundColor: Theme.of(context).primaryColor,
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
