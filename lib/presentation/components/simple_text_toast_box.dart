import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../services/theme_provider.dart';

class SimpleTextToastBox extends StatelessWidget {
  final String text;

  const SimpleTextToastBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = context.read<ThemeProvider>().isDarkMode;
    return Container(
      margin: EdgeInsets.only(bottom: 100),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/icons/app_icon.png', width: 20, height: 20))),
          const Gap(10),
          Text(text, style: TextStyle(color:isDark ? Colors.white : Colors.black),),
        ],
      ),
    );
  }
}
