import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:shimmer/shimmer.dart';
import 'package:test_us_app/presentation/components/alerts/one_button_alert.dart';
import 'package:test_us_app/services/common_height_provider.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/auth_bloc/auth_event.dart';
import '../../bloc/auth_bloc/auth_state.dart';

class FindUserEmailPage extends StatefulWidget {
  const FindUserEmailPage({super.key});

  @override
  State<FindUserEmailPage> createState() => _FindUserEmailPageState();
}

class _FindUserEmailPageState extends State<FindUserEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isValidateEmail = false;

  @override
  Widget build(BuildContext context) {
    // final hei = GetIt.I.get<ResponsiveHeightProvider>().hei!;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
        // height: hei - 60,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.7,
                  child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "등록한 이메일",
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isValidateEmail = true;
                          if (value.isEmpty) {
                            _isValidateEmail = false;
                          } else {
                            _isValidateEmail =
                                RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(_emailController.text);
                          }
                        });
                      }),
                ),
                const Gap(20),
                BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is FindEmailCompletedState) {
                        if (state.result) {
                          showDialog(
                              context: context,
                              builder: (context) => OneButtonAlert(
                                  title: '등록 확인',
                                  mainContent: '회원 등록된 이메일 입니다.',
                                  subContent: _emailController.text,
                                  buttonName: '확인',
                                  onPressed: () {
                                    Get.back();
                                  }));
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => OneButtonAlert(
                                  title: '알림',
                                  mainContent: '회원가입 된 이메일이 아닙니다.',
                                  buttonName: '확인',
                                  onPressed: () {
                                    Get.back();
                                  }));
                        }
                      }
                    },
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.5,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_emailController.text.isEmpty) {
                              Get.snackbar('알림', '이메일 입력 후 다시 시도해 주세요.');
                              return;
                            }
                            if (!_isValidateEmail) {
                              Get.snackbar('알림', '이메일 형식을 다시 확인해 주세요.');
                              return;
                            }
                            context.read<AuthBloc>().add(FindEmailEvent(_emailController.text));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('확인')),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _maskEmail(String email) {
    try {
      // 1. @ 기준으로 로컬(ID)과 도메인 분리
      final parts = email.split('@');
      if (parts.length != 2) return email;

      String local = parts[0];
      String domainFull = parts[1];

      // 2. 도메인을 다시 . 기준으로 분리 (도메인 이름과 확장자)
      final domainParts = domainFull.split('.');
      if (domainParts.length < 2) return email;

      String domainName = domainParts[0];
      String extension = domainParts[1];

      // --- 마스킹 처리 ---

      // 로컬: 첫 두 글자 + 나머지는 *
      String maskedLocal = local.length >= 2 ? local.substring(0, 2) + '*' * (local.length - 2) : '$local*';

      // 도메인 이름: 첫 글자 + 마지막 글자 (사이는 *)
      String maskedDomain = domainName.length >= 2
          ? domainName[0] + '*' * (domainName.length - 2) + domainName[domainName.length - 1]
          : '$domainName*';

      // 확장자: 첫 글자 + 나머지는 *
      String maskedExtension = extension.isNotEmpty ? extension[0] + '*' * (extension.length - 1) : "";

      return "$maskedLocal@$maskedDomain.$maskedExtension";
    } catch (e) {
      return '잘못된 이메일 형식입니다.'; // 에러 발생 시 원본 반환
    }
  }
}
