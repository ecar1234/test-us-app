import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';
import 'package:test_us_app/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:test_us_app/presentation/bloc/auth_bloc/auth_state.dart';
import 'package:test_us_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:test_us_app/presentation/pages/signup_page.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:test_us_app/utils/type_conversion_util.dart';

import '../../data/models/user/user_model.dart';
import '../../data/sharedPreferences/auth_preference.dart';
import '../bloc/auth_bloc/auth_event.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final pref = AuthPreference.instance;
  final logger = Logger();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GoogleSignInAccount? _currentUser;
  String _status = 'Not signed in';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // GoogleSignIn.instance.authenticationEvents.listen((event) {
    //   setState(() {
    //     if (event is GoogleSignInAuthenticationEventSignIn) {
    //       _currentUser = event.user;
    //       _status = 'Signed in: ${_currentUser?.displayName}';
    //     } else if (event is GoogleSignInAuthenticationEventSignOut) {
    //       _currentUser = null;
    //       _status = 'Signed out';
    //     }
    //   });
    // });
    //
    // GoogleSignIn.instance.attemptLightweightAuthentication();
  }

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
            appBar: AppBar(),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) async {
                    if (state.state == UserAuthState.loginCompletedState) {
                      // context.read<UserProvider>().autoLogin(state.token!, state.user!);
                      // context.read<BasePostBloc>().add(RequestUserInItDataEvent(state.token!, state.user!.id!));
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: Container(
                                height: 200,
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                        child:
                                            Text("로그인", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                                    SizedBox(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  child: Text(state.user!.nickname!,
                                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                              SizedBox(child: Text(" 님 환영햡니다.")),
                                            ],
                                          ),
                                          Text("오늘도 함께 발전하는 하루가 됐으면 합니다."),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                          child: Text("확인")),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                      Get.back();
                      return;
                    } else if (state.state == UserAuthState.loginPendingState) {
                      final wid = MediaQuery.sizeOf(context).width - 80;
                      final TextEditingController roleController = TextEditingController();
                      final TextEditingController userTypeController = TextEditingController();

                      await showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                                child: Container(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  const Text('유져 정보 입력', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  const Gap(20),
                                  SizedBox(
                                    child: Row(children: [
                                      Flexible(
                                          flex: 2,
                                          child: SizedBox(
                                            width: wid * 0.2,
                                            child: Text('타입',
                                                style: TextStyle(
                                                    fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black54)),
                                          )),
                                      Flexible(
                                          flex: 8,
                                          child: SizedBox(
                                            child: DropdownMenu(
                                                controller: userTypeController,
                                                menuHeight: 300,
                                                inputDecorationTheme: InputDecorationTheme(
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                ),
                                                dropdownMenuEntries: [
                                                  DropdownMenuEntry(value: "", label: "선택"),
                                                  DropdownMenuEntry(value: "INDIVIDUALS", label: "1인 개발자"),
                                                  DropdownMenuEntry(value: "COMPANIES", label: "기업"),
                                                ]),
                                          ))
                                    ]),
                                  ),
                                  const Gap(10),
                                  SizedBox(
                                    child: Row(children: [
                                      Flexible(
                                          flex: 2,
                                          child: SizedBox(
                                            width: wid * 0.2,
                                            child: Text('역할',
                                                style: TextStyle(
                                                    fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black54)),
                                          )),
                                      Flexible(
                                          flex: 8,
                                          child: SizedBox(
                                            height: 60,
                                            width: wid * 0.8,
                                            child: DropdownMenu(
                                                controller: roleController,
                                                menuHeight: 300,
                                                inputDecorationTheme: InputDecorationTheme(
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                ),
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
                                  ),
                                  const Gap(20),
                                  SizedBox(
                                    height: 50,
                                    width: wid,
                                    child: SizedBox(
                                      child: ElevatedButton(
                                          onPressed: () {
                                            if (userTypeController.text.isEmpty || roleController.text.isEmpty) {
                                              Get.snackbar("알림", "유저 타입 또는 역할은 빈 값으로 설정할 수 없습니다.");
                                              return;
                                            }

                                            final userInfo = UserEntity(
                                                email: state.user!.email,
                                                id: state.user!.id,
                                                nickname: state.user!.nickname,
                                                role: TypeConversionUtil().toUserRole(roleController.text),
                                                userType: TypeConversionUtil().toUserType(userTypeController.text),
                                                method: AuthType.google
                                            );
                                            context.read<AuthBloc>().add(GoogleLoginEvent(userInfo));
                                          },
                                          child: Text("가입 후 로그인")),
                                    ),
                                  )
                                ],
                              ),
                            ));
                          });
                    } else if (state.state == UserAuthState.loginFailedState) {
                      Get.snackbar("로그인 실패", state.message!);
                      return;
                    } else if(state.state == UserAuthState.authFailedState){
                      Get.snackbar("로그인 실패", state.message!);
                      return;
                    }
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
                            width: 180,
                            height: 40,
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                                    Get.snackbar("로그인 실패", "이메일 또는 비밀번호는 빈 값으로 설정할 수 없습니다.");
                                    return;
                                  }
                                  context
                                      .read<AuthBloc>()
                                      .add(EmailLoginEvent(emailController.text, passwordController.text));
                                },
                                child: Text("로그인")),
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
                                    onPressed: () {
                                      Get.to(() => const SignupPage());
                                    },
                                    child: Text(
                                      "회원가입",
                                      style: TextStyle(fontSize: 12, color: Colors.blue),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Gap(20),
                          _divider(),
                          const Gap(20),
                          _oAuthButtons(context)
                        ],
                      ),
                    ),
                  )),
            )));
  }

  List<Widget> _title() {
    return [
      SizedBox(
        child: Text(
          "Testus(테스터스)로 들어가기",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
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

  Widget _infoTextFields() {
    return SizedBox(
      child: Column(
        children: [
          SizedBox(
            width: 320,
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
          ),
          const Gap(20),
          SizedBox(
            width: 320,
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
          )
        ],
      ),
    );
  }

  Widget _divider() {
    return Row(
      children: [
        Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "OR",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
        Expanded(child: Divider()),
      ],
    );
  }

  Widget _oAuthButtons(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                try {
                  context.read<AuthBloc>().add(RequestGoogleAuth());
                } catch (error) {
                  print('Google Sign-in error: $error');
                  setState(() => _status = 'Sign-in failed');
                }
              },
              child: SizedBox(
                width: 50,
                child: SvgPicture.asset(
                  "assets/icons/android_light_rd_na.svg",
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const Gap(30),
            GestureDetector(
              onTap: ()async{
                try {
                  final res = await FlutterNaverLogin.logIn();
                  logger.d(res.status);
                } on Exception catch (e) {
                  // TODO
                  logger.i(e.toString());
                }
              },
              child: SizedBox(
                width: 50,
                child: Image.asset(
                  "assets/icons/naver_icon_btnG.png",
                  height: 50,
                ),
              ),
            ),
          ],
        ),
    );
  }
}
