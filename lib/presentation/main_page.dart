import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class MetaDataSetting extends StatefulWidget {
  const MetaDataSetting({super.key});

  @override
  State<MetaDataSetting> createState() => _MetaDataSettingState();
}

class _MetaDataSettingState extends State<MetaDataSetting> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: FlexThemeData.light(
        scheme: FlexScheme.blackWhite,
        useMaterial3: true,
      ),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.blackWhite, useMaterial3: true),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainState();
}

class _MainState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('TestUs'), // 추후 로고 이미지로 변경
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(Icons.menu),
                  );
                }
              ),
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.login)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
              ],
              centerTitle: true,
            ),
            drawer: Drawer(
              child: ListView(padding: EdgeInsets.zero, children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text('Drawer Header'),
                ),
              ]),
            ),
            body: const Center(
              child: Text('Main'),
            )));
  }
}
