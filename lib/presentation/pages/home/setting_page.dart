

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:test_us_app/services/theme_provider.dart';

import '../../../services/revenue_cat_purchases/purchase_management.dart';

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
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('구매복원', style: Theme.of(context).textTheme.titleLarge,),
                    SizedBox(
                      height: 40,
                      width: 100,
                      child: ElevatedButton(
                        onPressed: (){
                          context.read<PurchasesManagements>().restore();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Theme.of(context).colorScheme.primary
                        ),
                        child: Text('복원 요청', style: TextStyle(color: Colors.white))
                      )
                    )
                  ]
                ),
              ),
            )
          ],
        ),
      )
    ));
  }
}
