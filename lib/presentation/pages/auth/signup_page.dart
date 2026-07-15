import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';
import 'package:test_us_app/presentation/components/alerts/one_button_alert.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:test_us_app/utils/type_conversion_util.dart';

import '../../../data/models/user/user_model.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final logger = Logger();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordCheckController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController userTypeController = TextEditingController();
  TextEditingController roleController = TextEditingController();

  bool isEmailVisible = false;
  bool isPasswordVisible = false;
  bool isPasswordCheckVisible = false;
  bool isNicknameVisible = false;

  bool isValidateEmail = false;
  bool isValidatePassword = false;
  bool isValidatePasswordCheck = false;
  bool isValidateNickname = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordCheckController.dispose();
    nicknameController.dispose();
    userTypeController.dispose();
    roleController.dispose();
  }

  // UserRole _toUserRole(String role) {
  //   switch (role) {
  //     case "프로그래머":
  //       return UserRole.programmer;
  //     case "기획자":
  //       return UserRole.planner;
  //     case "마케터":
  //       return UserRole.marketer;
  //     case "디자이너":
  //       return UserRole.designer;
  //     case "퍼블리셔":
  //       return UserRole.publisher;
  //     case "데이터 분석":
  //       return UserRole.analyst;
  //     case "서비스 운영":
  //       return UserRole.operator;
  //     case "PM":
  //       return UserRole.pm;
  //     case "QA":
  //       return UserRole.qa;
  //     case "CS":
  //       return UserRole.cs;
  //     default:
  //       return UserRole.programmer;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // final height = GetIt.I.get<ResponsiveHeightProvider>().hei;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("회원가입"),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              // height: height,
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // email
                  _emailSection(),
                  const Gap(10),
                  // password
                  _passwordSection(),
                  const Gap(10),
                  // password check
                  _passwordCheckSection(),
                  const Gap(10),
                  // nickname
                  _nicknameSection(),
                  const Gap(10),
                  // user type
                  _userTypeSection(),
                  const Gap(40),
                  SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!isValidateEmail) {
                            Get.snackbar("알림", "이메일 형식을 다시 확인해 주세요.");
                            return;
                          }
                          if (!isValidatePassword) {
                            Get.snackbar("알림", "비밀번호 형식을 다시 확인해 주세요.");
                            return;
                          }
                          if (!isValidatePasswordCheck) {
                            Get.snackbar("알림", "비밀번호 확인이 일치하지 않습니다.");
                            return;
                          }
                          if (!isValidateNickname) {
                            Get.snackbar("알림", "닉네임 중복 확인을 해주세요.");
                            return;
                          }
                          if (userTypeController.text.isEmpty) {
                            Get.snackbar("알림", "유저 타입을 선택해 주세요.");
                            return;
                          }
                          if (roleController.text.isEmpty) {
                            Get.snackbar("알림", "역할을 선택해 주세요.");
                            return;
                          }
                          final userInfo = UserEntity(
                              email: emailController.text,
                              password: passwordController.text,
                              nickname: nicknameController.text,
                              userType: TypeConversionUtil().toUserType(userTypeController.text),
                              role: TypeConversionUtil().toUserRole(roleController.text),
                              method: AuthType.email);
                          try {
                            // logger.i('회원가입 시도: ${{
                            //   "email": userInfo.email,
                            //   "password": userInfo.password,
                            //   "nickname": userInfo.nickname,
                            //   "userType": userInfo.userType,
                            //   "role": userInfo.role
                            // }}');
                            final state = await context.read<UserProvider>().signup(userInfo);
                            // final isSignup = false;
                            if (context.mounted) {
                              if (state == 200) {
                                await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        child: OneButtonAlert(
                                            mainContent: "함께 해주셔서 감사합니다.",
                                            subContent: "모두가 함께 인사이트를 얻었으면 합니다.",
                                            buttonName: "확인",
                                            onPressed: () {
                                              Get.back(result: true);
                                            }),
                                      );
                                    });
                                Get.back();
                              } else if (state == 409) {
                                Get.snackbar("회원 가입 실패", "존재 하거나, 사용 할 수 없는 이메일 입니다.\n다른 이메일을 사용해 주세요.");
                                return;
                              }
                            }
                          } on Exception catch (e, stackTrace) {
                            // TODO
                            // 구체적인 에러 타입에 따른 분기 처리 권장
                            logger.e('회원가입 중 에러 발생: $e');
                            logger.i('Stack trace: $stackTrace');
                            if (context.mounted) {
                              // 사용자에게 일반적인 에러 메시지 표시
                              Get.snackbar("에러", "회원가입 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.");
                              return;
                              // 또는 특정 에러에 맞는 메시지 표시
                              // if (e is NetworkException) { ... }
                            }
                          }

                          // Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Text("회원가입"),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailSection() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "이메일",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const Gap(8),
          SizedBox(
              child: TextField(
                  controller: emailController,
                  onChanged: (value) {
                    setState(() {
                      isEmailVisible = true;
                      if (value.isEmpty) {
                        isValidateEmail = false;
                      } else {
                        isValidateEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(emailController.text);
                      }
                    });
                  })),
          if (isEmailVisible && emailController.text.isNotEmpty)
            SizedBox(
                height: 20,
                child: Row(
                  children: [
                    isValidateEmail
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
                    isValidateEmail
                        ? SizedBox(
                            child: Text(
                              "올바른 이메일 형식입니다",
                              style: TextStyle(color: Colors.green),
                            ),
                          )
                        : SizedBox(
                            child: Text(
                              "이메일 형식을 다시 확인해 주세요.",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          )
                  ],
                ))
          else
            SizedBox(
              height: 20,
            )
        ],
      ),
    );
  }

  Widget _passwordSection() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "비밀번호",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const Gap(4),
              Text(
                "( 8자 이상 / 영문, 숫자, 특수문자 포함 )",
                style: TextStyle(fontSize: 12, color: Colors.blueAccent),
              )
            ],
          ),
          const Gap(8),
          SizedBox(
              child: TextField(
            controller: passwordController,
            obscureText: true,
            onChanged: (value) {
              setState(() {
                isPasswordVisible = true;
                if (value.isEmpty) {
                  isPasswordVisible = false;
                } else {
                  isValidatePassword =
                      RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#\$&*~]).{8,}$').hasMatch(passwordController.text);
                }
              });
            },
          )),
          if (isPasswordVisible && passwordController.text.isNotEmpty)
            SizedBox(
                height: 20,
                child: Row(
                  children: [
                    isValidatePassword
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
                    isValidatePassword
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
            SizedBox(
              height: 20,
            )
        ],
      ),
    );
  }

  Widget _passwordCheckSection() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "비밀번호 확인",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const Gap(8),
          SizedBox(
              child: TextField(
            controller: passwordCheckController,
            obscureText: true,
            onChanged: (value) {
              setState(() {
                isPasswordCheckVisible = true;
                if (value.isEmpty) {
                  isPasswordCheckVisible = false;
                } else {
                  isValidatePasswordCheck = passwordController.text == passwordCheckController.text;
                }
              });
            },
          )),
          if (isPasswordCheckVisible && passwordCheckController.text.isNotEmpty)
            SizedBox(
                height: 20,
                child: Row(
                  children: [
                    isValidatePasswordCheck
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
                    isValidatePasswordCheck
                        ? SizedBox(
                            child: Text("비밀번호가 일치 합니다.", style: TextStyle(color: Colors.green)),
                          )
                        : SizedBox(
                            child: Text("비밀번호가 일치하지 않습니다.", style: TextStyle(color: Colors.redAccent)),
                          )
                  ],
                ))
          else
            SizedBox(
              height: 20,
            )
        ],
      ),
    );
  }

  Widget _nicknameSection() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "닉네임",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const Gap(8),
          SizedBox(
              child: Row(
            children: [
              Flexible(
                flex: 8,
                child: SizedBox(
                  width: (MediaQuery.sizeOf(context).width - 40) * 0.7,
                  child: TextField(
                    controller: nicknameController,
                  ),
                ),
              ),
              const Gap(16),
              Flexible(
                flex: 2,
                child: SizedBox(
                  width: (MediaQuery.sizeOf(context).width - 40) * 0.2,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (nicknameController.text.isEmpty) {
                        Get.snackbar("알림", "닉네임을 입력해 주세요.");
                        return;
                      }
                      final isNickname =
                          await context.read<UserProvider>().isNicknameAvailable(nicknameController.text);
                      if (!isNickname) {
                        Get.snackbar("알림", "이미 사용중인 닉네임 입니다.");
                        setState(() {
                          isNicknameVisible = true;
                          isValidateNickname = false;
                        });
                        return;
                      } else {
                        setState(() {
                          isNicknameVisible = true;
                          isValidateNickname = true;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text("중복확인"),
                  ),
                ),
              )
            ],
          )),
          if (isNicknameVisible && nicknameController.text.isNotEmpty)
            SizedBox(
                height: 20,
                child: Row(
                  children: [
                    isValidateNickname
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
                    isValidateNickname
                        ? SizedBox(
                            child: Text(
                              "사용할 수 있는 닉네임 입니다.",
                              style: TextStyle(color: Colors.green),
                            ),
                          )
                        : SizedBox(
                            child: Text(
                              "이미 사용중인 닉네임 입니다.",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          )
                  ],
                ))
          else
            SizedBox(
              height: 20,
            )
        ],
      ),
    );
  }

  Widget _userTypeSection() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width - 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: SizedBox(
              width: (MediaQuery.sizeOf(context).width - 40) / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      child: Text(
                    "유져 타입",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  )),
                  const Gap(8),
                  SizedBox(
                    child: DropdownMenu(
                        controller: userTypeController,
                        menuHeight: 300,
                        inputDecorationTheme: InputDecorationTheme(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        initialSelection: "",
                        dropdownMenuEntries: [
                          DropdownMenuEntry(value: "", label: "선택"),
                          DropdownMenuEntry(value: "INDIVIDUALS", label: "1인 개발자"),
                          DropdownMenuEntry(value: "COMPANIES", label: "기업"),
                          DropdownMenuEntry(value: "NORMAL", label: "일반(비개발자)"),
                        ]),
                  )
                ],
              ),
            ),
          ),
          const Gap(5),
          Flexible(
            flex: 1,
            child: SizedBox(
              width: (MediaQuery.sizeOf(context).width - 40) / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      child: Text(
                    "역할",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  )),
                  const Gap(8),
                  SizedBox(
                    child: DropdownMenu(
                        controller: roleController,
                        menuHeight: 300,
                        inputDecorationTheme: InputDecorationTheme(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        initialSelection: "",
                        dropdownMenuEntries: [
                          DropdownMenuEntry(value: "", label: "선택"),
                          DropdownMenuEntry(value: "programmer", label: "프로그래머"),
                          DropdownMenuEntry(value: "planner", label: "기획자"),
                          DropdownMenuEntry(value: "marketer", label: "마케터"),
                          DropdownMenuEntry(value: "designer", label: "디자이너"),
                          DropdownMenuEntry(value: "publisher", label: "퍼블리셔"),
                          DropdownMenuEntry(value: "analyst", label: "데이터 분석"),
                          DropdownMenuEntry(value: "operator", label: "서비스 운영"),
                          DropdownMenuEntry(value: "manager", label: "PM"),
                          DropdownMenuEntry(value: "qa", label: "QA"),
                          DropdownMenuEntry(value: "cs", label: "CS"),
                        ]),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
