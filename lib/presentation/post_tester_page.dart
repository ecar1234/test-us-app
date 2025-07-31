
import 'package:flutter/material.dart';

class PostTesterPage extends StatefulWidget {
  const PostTesterPage({super.key});

  @override
  State<PostTesterPage> createState() => _PostTesterPageState();
}

class _PostTesterPageState extends State<PostTesterPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('Post Tester page'),
      ),
    ));
  }
}
