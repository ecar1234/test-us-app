
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:test_us_app/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:test_us_app/presentation/signup_page.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:provider/provider.dart';

import 'bloc/auth_bloc/auth_event.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = GetIt.I.get<ResponsiveHeightProvider>().hei;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              height: height,
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ..._title(),
                  const Gap(40),
                  _infoTextFields(),
                  const Gap(20),
                  // 로그인 버튼
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () async {
                          if(emailController.text.isEmpty || passwordController.text.isEmpty){
                            Get.snackbar("로그인 실패", "이메일 또는 비밀번호는 빈 값으로 설정할 수 없습니다.");
                            return;
                          }
                          final isLogin = await context.read<UserProvider>().login(emailController.text, passwordController.text);
                          if(context.mounted){
                            if(isLogin == 401){
                              Get.snackbar("로그인 실패", "이메일 또는 비밀번호가 일치하지 않습니다.");
                              return;
                            }
                            final user = context.read<UserProvider>().user;
                            context.read<AuthBloc>().add(LoginEvent(user!));
                            // context.read<AuthBloc>().add(LoginCompletedEvent(context));
                            await showDialog(context: context, builder: (context) {
                              return AlertDialog(
                                title: Text("로그인 성공"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("함께 해주셔서 감사합니다."),
                                  ],
                                ),
                                actions: [
                                  SizedBox(
                                    child: ElevatedButton(onPressed: (){
                                      Get.back(result: true);
                                    }, child: Text("확인")),
                                  )
                                ],
                              );
                            });
                            Get.back();
                          }
                        },
                        child: Text("로그인")
                    ),
                  ),
                  // 회원가입 버튼
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Text("아직 회원이 아니신가요?", style: TextStyle(fontSize: 12)),
                        ),
                        SizedBox(
                          child: TextButton(
                            onPressed: (){
                              Get.to(() => const SignupPage());
                            },
                            child: Text("회원가입", style: TextStyle(fontSize: 12, color: Colors.blue),),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Gap(20),
                  _divider(),
                  const Gap(20),
                  ..._oAuthButtons()
                ],
              ),
            ),
          ),
        )
    ));
  }

  List<Widget> _title(){
    return [
      SizedBox(
        child:  Text("Testus(테스터스)로 들어가기", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),),
      ),
      const Gap(10),
      SizedBox(
        child: Text("Testus를 통해 개발 서비스의 방향성을 찾고,"),
      ),
      SizedBox(
        child: Text("테스트를 진행 하면서 인사이트를 얻어보세요."),
      )
    ];
  }

  Widget _infoTextFields(){
    return SizedBox(
      child: Column(
        children: [
          SizedBox(
            width: 320,
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: "Email"
              ),
            ),
          ),
          const Gap(20),
          SizedBox(
            width: 320,
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Password"
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _divider(){
    return Row(
      children: [
        Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text("OR", style: TextStyle(fontSize: 14, color: Colors.grey),),
        ),
        Expanded(child: Divider()),
      ],
    );
  }

  List<Widget> _oAuthButtons(){
    return [
      SizedBox(
        width: 320,
        height: 50,
        child: ElevatedButton(
          onPressed: (){},
          child: Row(
            children: [
              Text("Google login")
            ],
          )
        )
      ),
      const Gap(20),
      SizedBox(
          width: 320,
          height: 50,
          child: ElevatedButton(
              onPressed: (){},
              child: Row(
                children: [
                  Text("Naver Login")
                ],
              )
          )
      ),
    ];
  }
}