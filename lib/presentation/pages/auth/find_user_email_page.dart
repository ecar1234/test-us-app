import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:shimmer/shimmer.dart';
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
  final TextEditingController _nickNameController = TextEditingController();

  bool _isFind = false;
  String? _addr;
  String? _message;

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
                      controller: _nickNameController,
                      decoration: InputDecoration(
                        labelText: "닉네임",
                      )),
                ),
                const Gap(20),
                BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is FindEmailCompletedState) {
                        setState(() {
                          _isFind = true;
                          _addr = _maskEmail(state.email);
                        });
                      } else if (state.state == UserAuthState.failedState) {
                        setState(() {
                          _isFind = false;
                          _message = state.message;
                        });
                      } else if (state.state == UserAuthState.errorState) {
                        setState(() {
                          _isFind = false;
                          _message = state.message;
                        });
                      }
                    },
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.5,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            if (_nickNameController.text.isEmpty) {
                              Get.snackbar('알림', '닉네임은 빈 값으로 설정할 수 없습니다.');
                              return;
                            }
                            context.read<AuthBloc>().add(FindEmailEvent(_nickNameController.text));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('확인')),
                    )),
              ],
            ),
            const Gap(30),
            if(_isFind == false && (_addr == null && _message == null))
              SizedBox(
                height: 70,
              )
            else if(_isFind == false &&  _message != null)
              SizedBox(
                height: 70,
                child: Text(_message!, style: TextStyle(color: Colors.red, fontSize: 16),),
              )
            else if(_isFind == true && _addr != null)
              SizedBox(
                height: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('찾은 이메일', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    Text(_addr!, style: TextStyle(color: Colors.blue, fontSize: 18),),
                  ],
                ),
              )
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
