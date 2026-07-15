import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TwoButtonConfirmAlert extends StatelessWidget {
  const TwoButtonConfirmAlert({
    super.key,
    this.width = 300,
    this.height = 200,
    this.title,
    required this.mainContent,
    this.subContent,
    required this.confirmButtonName,
    required this.cancelButtonName,
    required this.onPressedConfirm,
    required this.onPressedCancel,
    this.titleSize = 22,
    this.mainContentSize = 14,
    this.subContentSize = 14,
  });

  final double? width;
  final double? height;
  final String? title;
  final String mainContent;
  final String? subContent;
  final String confirmButtonName;
  final String cancelButtonName;
  final VoidCallback onPressedConfirm;
  final VoidCallback onPressedCancel;
  final double titleSize;
  final double mainContentSize;
  final double subContentSize;

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
            if (title != null)
              Text(
                title!,
                style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
              )
            else
              const Gap(30),
            if (title != null) const Gap(10),
            Expanded(
                child: Column(
                  children: [
                    Text(
                      mainContent,
                      style: TextStyle(fontSize: mainContentSize),
                    ),
                    const Gap(10),
                    if (subContent != null)
                      Text(
                        subContent!,
                        style: TextStyle(fontSize: subContentSize),
                      ),
                  ],
                )),
            LayoutBuilder(builder: (context, constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 3,
                    child: SizedBox(
                      width: constraints.maxWidth * 0.3,
                      child: OutlinedButton(
                          onPressed: onPressedCancel,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Theme.of(context).colorScheme.primary),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(cancelButtonName)),
                    ),
                  ),
                  const Gap(10),
                  Flexible(
                    flex: 7,
                    child: SizedBox(
                      width: constraints.maxWidth * 0.7,
                      child: ElevatedButton(
                          onPressed: onPressedConfirm,
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(confirmButtonName)),
                    ),
                  )
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}