import 'package:flutter/material.dart';

class DoubleActionsDialog extends StatelessWidget {
  final String title;
  final String contents1;
  final String? contents2;
  final String? contents3;
  final String leftText;
  final String rightText;
  final VoidCallback onLeft;
  final VoidCallback onRight;

  const DoubleActionsDialog({
    super.key,
    required this.title,
    required this.contents1,
    this.contents2,
    this.contents3,
    required this.leftText,
    required this.rightText,
    required this.onLeft,
    required this.onRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(
            child: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            child: Text(
              contents1,
              style: TextStyle(fontSize: 16),
            ),
          ),
          if (contents2 != null)
            SizedBox(
              child: Text(
                contents2!,
                style: TextStyle(fontSize: 16),
              ),
            ),
          if (contents3 != null)
            SizedBox(
              child: Text(
                contents3!,
                style: TextStyle(fontSize: 16),
              ),
            ),
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Flexible(
                  flex: 3,
                  child: SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.3,
                      child: ElevatedButton(
                          onPressed: onLeft,
                          child: Text(leftText)
                      )),
                ),
                Flexible(
                  flex: 7,
                  child: SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.7,
                      child: ElevatedButton(
                          onPressed: onRight,
                          child: Text(rightText)
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
