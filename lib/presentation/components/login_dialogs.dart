
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../pages/login_page.dart';

class LoginDialog extends StatelessWidget {
  const LoginDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return  Dialog(
        child: Container(
          padding: EdgeInsets.all(20),
          height: 200,
          child: Column(
            children: [
              SizedBox(
                  height: 100,
                  child: Center(
                    child: Text("로그인이 필요합니다.",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  )
              ),
              SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 100,
                        child: ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
                            ),
                            child: Text("확인")),
                      ),
                      const Gap(20),
                      SizedBox(
                        height: 40,
                        width: 100,
                        child: ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                              Get.to(() => const LoginPage());
                            },
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
                            ),
                            child: Text("로그인")),
                      )
                    ],
                  )
              )
            ],
          ),
        )
    );
  }
}
