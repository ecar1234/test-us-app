import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OneButtonAlert extends StatelessWidget {
  const OneButtonAlert({super.key,
    this.width = 300,
    this.height = 200,
    this.title,
    required this.mainContent,
    this.subContent,
    required this.buttonName,
    required this.onPressed
  });
  final double? width;
  final double? height;
  final String? title;
  final String mainContent;
  final String? subContent;
  final String buttonName;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(title != null)
              Text(title!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
            else
              const Gap(100),
            if(title != null)
              const Gap(10),
            Expanded(
              child: Column(
                children: [
                  Text(mainContent, style: TextStyle(fontSize: 14),),
                  const Gap(10),
                  if(subContent != null)
                  Text(subContent!, style: TextStyle(fontSize: 14),),
                ],
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  width: 100,
                  child: ElevatedButton(
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                      child: Text(buttonName,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                              FontWeight.bold))),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
