

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:test_us_app/services/theme_provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei ?? 0;
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return SafeArea(child: Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: hei,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Dark Mode", style: Theme.of(context).textTheme.titleLarge,),
                    Switch(
                        value: isDark,
                        onChanged: (bool value){
                      context.read<ThemeProvider>().changedThemeMode(value);
                    },

                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )
    ));
  }
}
