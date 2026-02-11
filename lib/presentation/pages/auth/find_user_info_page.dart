import 'package:flutter/material.dart';
import 'package:test_us_app/presentation/pages/auth/find_user_email_page.dart';

import 'find_password_page.dart';

class FindUserInfoPage extends StatefulWidget {
  const FindUserInfoPage({super.key});

  @override
  State<FindUserInfoPage> createState() => _FindUserInfoPageState();
}

class _FindUserInfoPageState extends State<FindUserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("계정 찾기"),
        ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(tabs: [
                Tab(text: '이메일 찾기',),
                Tab(text: '비밀번호 찾기',)

              ]),
              Expanded(
                child: TabBarView(
                    children: [
                      FindUserEmailPage(),
                      FindPasswordPage()
                    ]
                ),
              )
            ],
          ),
        )
      )
    );
  }
}
