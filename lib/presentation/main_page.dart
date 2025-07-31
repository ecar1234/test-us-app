import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:test_us_app/presentation/login_page.dart';
import 'package:test_us_app/presentation/setting_page.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class MetaDataSetting extends StatefulWidget {
  const MetaDataSetting({super.key});

  @override
  State<MetaDataSetting> createState() => _MetaDataSettingState();
}

class _MetaDataSettingState extends State<MetaDataSetting> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() => loadSetting());
  }

  Future<void> loadSetting() async {
    GetIt.I.get<ResponsiveHeightProvider>().setHeight(context);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: FlexThemeData.light(
          scheme: FlexScheme.ebonyClay,
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          blendLevel: 9,
          subThemesData: const FlexSubThemesData(
              blendOnLevel: 10,
              blendOnColors: false,
              inputDecoratorRadius: 10,
              inputCursorSchemeColor: SchemeColor.black,
              inputDecoratorIsFilled: false),
          useMaterial3: true,
          swapLegacyOnMaterial3: true,
          fontFamily: GoogleFonts.notoSans().fontFamily),
      darkTheme: FlexThemeData.dark(
          scheme: FlexScheme.ebonyClay,
          surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
          blendLevel: 15,
          subThemesData: const FlexSubThemesData(
              blendOnLevel: 20, inputDecoratorRadius: 10, inputCursorSchemeColor: SchemeColor.black, inputDecoratorIsFilled: false),
          useMaterial3: true,
          swapLegacyOnMaterial3: true),
      themeMode: ThemeMode.light,
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
    final hei = GetIt.I<ResponsiveHeightProvider>().hei;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Testus', style: TextStyle(fontWeight: FontWeight.bold)), // 추후 로고 이미지로 변경
              actions: [
                IconButton(onPressed: () {
                  Get.to(() => LoginPage());
                }, icon: const Icon(Icons.login)),
                IconButton(onPressed: () {
                  Get.to(() => SettingPage());
                }, icon: const Icon(Icons.settings)),
              ],
            ),
            // drawer: Drawer(
            //   child: ListView(padding: EdgeInsets.zero, children: [
            //     Container(
            //         height: 100,
            //         width: MediaQuery.sizeOf(context).width,
            //         padding: EdgeInsets.all(10),
            //         // decoration: BoxDecoration(
            //         //   border: Border.all()
            //         // ),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             SizedBox(
            //               child: Text(
            //                 'Testus',
            //                 style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            //               ),
            //             ),
            //             // SizedBox(
            //             //   width: 40,
            //             //   height: 40,
            //             //   child: IconButton(onPressed: () {
            //             //     Navigator.pop(context);
            //             //   }, icon: Icon(Icons.arrow_back_ios)),
            //             // )
            //
            //           ],
            //         )),
            //     Container(padding: EdgeInsets.symmetric(horizontal: 20), child: Divider()),
            //     const Gap(20),
            //     ListTile(
            //       title: Text("테스터 모집"),
            //       onTap: () {},
            //     ),
            //     ListTile(
            //       title: Text("서비스 홍보"),
            //       onTap: () {},
            //     ),
            //     ListTile(
            //       title: Text("지원 현황"),
            //       onTap: () {},
            //     ),
            //     ListTile(
            //       title: Text("커뮤니티"),
            //       onTap: () {},
            //     ),
            //   ]),
            //
            // ),
            body: SingleChildScrollView(
                child: Container(
                    // height: hei,
                    width: MediaQuery.sizeOf(context).width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    // decoration: BoxDecoration(
                    //   border: Border.all()
                    // ),
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: MediaQuery.sizeOf(context).width,
                          // decoration: BoxDecoration(
                          //   border: Border.all()
                          // ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  height: 80,
                                  width: (MediaQuery.sizeOf(context).width - 80) / 4,
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                      child: Center(
                                        child: Text("테스터 모집"),
                                      ))),
                              const Gap(10),
                              SizedBox(
                                  height: 80,
                                  width: (MediaQuery.sizeOf(context).width - 80) / 4,
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                      child: Center(
                                        child: Text("서비스 홍보"),
                                      ))),
                              const Gap(10),
                              SizedBox(
                                  height: 80,
                                  width: (MediaQuery.sizeOf(context).width - 80) / 4,
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                      child: Center(
                                        child: Text("지원 현황"),
                                      ))),
                              const Gap(10),
                              SizedBox(
                                  height: 80,
                                  width: (MediaQuery.sizeOf(context).width - 80) / 4,
                                  child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                      child: Center(
                                        child: Text("커뮤니티"),
                                      ))),
                            ],
                          ),
                        ),
                        const Gap(20),
                        _favoritePostList(),
                        const Gap(20),
                        _appServiceList(),
                        const Gap(20),
                        _appServiceList()
                      ],
                    )))));
  }

  Widget _favoritePostList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text("조회 Top 10", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Container(
            height: 230,
            width: MediaQuery.sizeOf(context).width,
            // padding: EdgeInsets.all(10),

            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 20),
                shrinkWrap: true,
                itemBuilder: (context, idx) {
                  return Container(
                    height: 200,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Text("${idx + 1}"),
                  );
                },
                separatorBuilder: (context, idx) => const Gap(10),
                itemCount: 10)),
      ],
    );
  }

  Widget _appServiceList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('앱 서비스', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              TextButton(onPressed: () {}, style: TextButton.styleFrom(padding: EdgeInsets.zero), child: Text("더보기"))
            ],
          ),
        ),
        SizedBox(
            height: 150,
            width: MediaQuery.sizeOf(context).width,
            // padding: EdgeInsets.all(10),
            // decoration: BoxDecoration(
            //     border: Border.all()
            // ),
            child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 20),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, idx) {
                  return Container(
                    height: 120,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Text("$idx"),
                  );
                },
                separatorBuilder: (context, idx) => const Gap(10),
                itemCount: 4)),
      ],
    );
  }
}
