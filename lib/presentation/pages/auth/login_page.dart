import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';
import 'package:test_us_app/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:test_us_app/presentation/bloc/auth_bloc/auth_state.dart';
import 'package:test_us_app/presentation/pages/auth/signup_page.dart';
import 'package:test_us_app/services/auth/auth_service.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:test_us_app/utils/type_conversion_util.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/models/user/user_model.dart';
import '../../../data/sharedPreferences/auth_preference.dart';
import '../../bloc/auth_bloc/auth_event.dart';
import 'find_user_info_page.dart';

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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = GetIt.I.get<ResponsiveHeightProvider>().hei ?? 0;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(),
            body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) async {
                    if (state.state == UserAuthState.loginCompletedState) {
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
                                            // GetIt.I.get<AuthService>().loginCompletionHandler(context, state);
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
                    } else if (state.state == UserAuthState.authLoginCompletedState) {
                      final wid = MediaQuery.sizeOf(context).width - 80;
                      final TextEditingController roleController = TextEditingController();
                      final TextEditingController userTypeController = TextEditingController();

                      await showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: LayoutBuilder(
                                builder: (BuildContext context, BoxConstraints constraints) => Container(
                                    height: height * 0.6,
                                    width: constraints.maxWidth > 600 ? 600 : wid,
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              height: 40,
                                              child: const Text('추가 정보',
                                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                                          Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                          flex: 3,
                                                          child: SizedBox(
                                                            width: wid * 0.3,
                                                            child: Text('이메일',
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                                textAlign: TextAlign.center),
                                                          )),
                                                      Flexible(
                                                          flex: 7,
                                                          child: SizedBox(
                                                              width: wid * 0.7,
                                                              child: Text(state.user!.email!,
                                                                  style: TextStyle(fontSize: 18)))),
                                                    ],
                                                  ),
                                                ),
                                                const Gap(20),
                                                SizedBox(
                                                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                  Flexible(
                                                      flex: 3,
                                                      child: SizedBox(
                                                        width: wid * 0.3,
                                                        child: Text('닉네임',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                            textAlign: TextAlign.center),
                                                      )),
                                                  Flexible(
                                                      flex: 7,
                                                      child: SizedBox(
                                                          width: wid * 0.7,
                                                          child: Text(
                                                            state.user!.nickname ?? "",
                                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                          )))
                                                ])),
                                                const Gap(20),
                                                SizedBox(
                                                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                    Flexible(
                                                        flex: 3,
                                                        child: SizedBox(
                                                          width: wid * 0.3,
                                                          child: Text('타입',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                              textAlign: TextAlign.center),
                                                        )),
                                                    Flexible(
                                                        flex: 7,
                                                        child: SizedBox(
                                                          width: wid * 0.7,
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
                                                                DropdownMenuEntry(
                                                                    value: "INDIVIDUALS", label: "1인 개발자"),
                                                                DropdownMenuEntry(value: "COMPANIES", label: "기업"),
                                                              ]),
                                                        ))
                                                  ]),
                                                ),
                                                const Gap(20),
                                                SizedBox(
                                                  child: Row(children: [
                                                    Flexible(
                                                        flex: 3,
                                                        child: SizedBox(
                                                          width: wid * 0.3,
                                                          child: Text(
                                                            '역할',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        )),
                                                    Flexible(
                                                        flex: 7,
                                                        child: SizedBox(
                                                          height: 60,
                                                          width: wid * 0.7,
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
                                              ]),
                                          SizedBox(
                                            height: 50,
                                            width: wid * 0.5,
                                            child: SizedBox(
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    if (userTypeController.text.isEmpty ||
                                                        roleController.text.isEmpty) {
                                                      Get.snackbar("알림", "유저 타입 또는 역할은 빈 값으로 설정할 수 없습니다.");
                                                      return;
                                                    }

                                                    final userInfo = UserEntity(
                                                        email: state.user!.email,
                                                        id: state.user!.id,
                                                        nickname: state.user!.nickname,
                                                        role: TypeConversionUtil().toUserRole(roleController.text),
                                                        userType:
                                                            TypeConversionUtil().toUserType(userTypeController.text),
                                                        profileImg: state.user!.profileImg!,
                                                        method: state.message == 'naver'
                                                            ? AuthType.naver
                                                            : AuthType.google);

                                                    context.read<AuthBloc>().add(OauthLoginEvent(user: userInfo));
                                                    Get.back();
                                                  },
                                                  child: Text("확인",
                                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                            ),
                                          ),
                                        ])),
                              ),
                            );
                          });
                    } else if (state.state == UserAuthState.loginFailedState) {
                      Get.snackbar("로그인 실패", state.message!);
                      return;
                    } else if (state.state == UserAuthState.authFailedState) {
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
                          const Gap(40),
                          // 로그인 버튼
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.6,
                            height: 50,
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
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  backgroundColor: Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text("로그인")),
                          ),
                          const Gap(40),
                          // 회원가입 버튼
                          SizedBox(
                            height: 20,
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
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Text(
                                      "회원가입",
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Gap(5),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  child: Text("로그인이 안되나요?", style: TextStyle(fontSize: 12)),
                                ),
                                SizedBox(
                                  height: 20,
                                  child: TextButton(
                                    onPressed: () {
                                      Get.to(() => const FindUserInfoPage());
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Text(
                                      "계정 찾기",
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Gap(20),
                          _divider(),
                          const Gap(20),
                          _oAuthButtons(context),
                          const Gap(50),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              children: [
                                const TextSpan(text: '가입 시 '),
                                TextSpan(
                                  text: '이용약관',
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launchUrl(Uri.parse('https://devon-studio.vercel.app/#/terms_of_service'));
                                      debugPrint('이용약관');
                                    },
                                ),
                                const TextSpan(text: ' 및 '),
                                TextSpan(
                                  text: '개인정보처리방침',
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launchUrl(Uri.parse('https://devon-studio.vercel.app/#/privacy_policy'));
                                      debugPrint('개인정보');
                                    },
                                ),
                                const TextSpan(text: '에 동의하게 됩니다.'),
                              ],
                            ),
                          )
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
          "TESTUS(테스터스)로 들어가기",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
      const Gap(10),
      SizedBox(
        child: Text("TESTUS 통해 개발 서비스의 방향성을 찾고,"),
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
            width: MediaQuery.sizeOf(context).width * 0.7,
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
                prefixIconColor: Theme.of(context).primaryColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const Gap(20),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.7,
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock),
                prefixIconColor: Theme.of(context).primaryColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
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
                logger.e('Google Sign-in error: $error');
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
            onTap: () async {
              try {
                context.read<AuthBloc>().add(RequestNaverAuth());
              } catch (error) {
                logger.e('Naver Sign-in error: $error');
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
