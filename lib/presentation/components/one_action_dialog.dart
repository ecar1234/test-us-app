import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OneActionDialog extends StatelessWidget {
  final String title;
  final String contents1;
  final String? contents2;
  final String? contents3;
  final String buttonText;
  final VoidCallback onPressed;
  final double buttonWidth;

  const OneActionDialog({super.key ,
    required this.title,
    required this.contents1,
    this.contents2,
    this.contents3,
    required this.buttonText,
    required this.onPressed,
    this.buttonWidth = 100
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.3, minHeight: 200),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
            child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          ),
          const Divider(color: Colors.grey),
          const Gap(10),
          SizedBox(
            child: Text(contents1, style: TextStyle(fontSize: 16),),
          ),
          if(contents2 != null)
            SizedBox(
              child: Text(contents2!, style: TextStyle(fontSize: 16),),
            ),
          if(contents3 != null)
            SizedBox(
              child: Text(contents3!, style: TextStyle(fontSize: 16),),
            ),
          const Gap(20),
          SizedBox(
            height: 50,
            width: buttonWidth,
            child: ElevatedButton(onPressed: onPressed, child: Text(buttonText)),
          )
        ],
      ),
    );
  }
}
