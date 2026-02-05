import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:test_us_app/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:test_us_app/presentation/bloc/auth_bloc/auth_state.dart';
import 'package:test_us_app/presentation/pages/main_page.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';

import '../../../../services/common_height_provider.dart';
import '../../../bloc/auth_bloc/auth_event.dart';

class UserDeletePage extends StatefulWidget {
  const UserDeletePage({super.key});

  @override
  State<UserDeletePage> createState() => _UserDeletePageState();
}

class _UserDeletePageState extends State<UserDeletePage> {
  final List<String> terms = [
    '탈퇴 즉시 계정 사용이 불가하며, 7일간의 유예 기간 후 모든 정보가 파기됩니다.',
    '탈퇴 후 7일 이내에는 고객센터를 통해 복구 신청이 가능하나, 이후에는 어떠한 경우에도 복구가 불가능합니다.',
    '작성하신 게시물(포스트, 리뷰 등)은 탈퇴 후에도 삭제되지 않으므로, 삭제를 원하시면 탈퇴 전 직접 삭제해 주시기 바랍니다.',
    '소셜 로그인(네이버, 구글 등)을 이용 중인 경우, 탈퇴 후 해당 플랫폼의 설정에서 서비스 연결을 직접 해제하셔야 합니다.',
    '탈퇴 시 보유 이용권은 모두 소멸되며 재가입 시에도 복구되지 않습니다.',
    '단, 결제 정보 및 접속 기록 등은 관련 법령에 따라 명시된 기간 동안 안전하게 보관됩니다.',
  ];

  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei ?? 0;

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('회원 탈퇴'),
            ),
            body: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) async {
                if (state.state == UserAuthState.userDeleteCompletedState) {
                  context.read<UserProvider>().logout();
                  Get.offAll(() => MainPage());
                }
              },
              child: Container(
                  height: hei,
                  width: MediaQuery.sizeOf(context).width,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const Text(
                            '회원 탈퇴 규정',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 12),

                          // 2. List.generate를 이용한 리스트 생성
                          ...List.generate(terms.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0), // 각 항목 사이의 간격
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start, // 핵심: 위쪽 정렬
                                children: [
                                  const SizedBox(
                                    width: 20, // 기호가 차지할 고정 너비
                                    child: Text('⦁', style: TextStyle(fontSize: 14)),
                                  ),
                                  Expanded(
                                    child: Text(
                                      terms[index],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        // color: Colors.black87,
                                        height: 1.4, // 줄 간격 조절로 가독성 향상
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const Gap(30),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.5,
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () {
                                _showDialog(context);
                              },
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1,
                                ),
                              ),
                              child: Text('회원 탈퇴'),
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            )));
  }

  Future<void> _showDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: 200,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('탈퇴하시겠습니까?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                  const Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 160,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            )
                          ),
                          child: Text('취소'),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () {
                            final token = context.read<UserProvider>().token ?? "";
                            final userId = context.read<UserProvider>().user!.id ?? "";

                            context.read<AuthBloc>().add(RequestUserDeleteEvent(token, userId));
                            Get.back();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1,
                              ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            )
                          ),
                          child: Text('탈퇴'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          );
        });
  }
}
