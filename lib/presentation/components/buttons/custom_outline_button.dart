import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final double? textSize;
  final double? wid;
  final double? hei;
  final double? horizontalPadding;
  final double? verticalPadding;

  const CustomOutlineButton({
    super.key,
    required this.text,
    this.onPressed,
    this.wid = 100,
    this.hei = 40,
    this.textSize = 14,
    this.horizontalPadding = 10,
    this.verticalPadding = 10
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: wid,
      height: hei,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding??0, vertical: verticalPadding??0),
          side: BorderSide(color: onPressed == null ? Colors.grey : Theme.of(context).primaryColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(text,
          style: TextStyle(
            fontSize: textSize,
            color: onPressed == null ? Colors.grey : Theme.of(context).primaryColor,
          )
        )
      )
    );
  }
}
