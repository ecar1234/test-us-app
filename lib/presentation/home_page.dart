import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/presentation/post_tester_page.dart';
import 'package:test_us_app/presentation/provider/post_provider.dart';
import 'package:test_us_app/presentation/setting_page.dart';

import '../domain/entities/post_entity.dart';
import '../services/common_height_provider.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final Function(int) onTap;
  const HomePage({super.key, required this.onTap});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei ?? MediaQuery.sizeOf(context).height - 120;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Testus',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              // 추후 로고 이미지로 변경
              actions: [
                IconButton(
                    onPressed: () {
                      Get.to(() => LoginPage());
                    },
                    icon: const Icon(Icons.login)),
                IconButton(
                    onPressed: () {
                      Get.to(() => SettingPage());
                    },
                    icon: const Icon(Icons.settings)),
              ],
            ),
            body: SizedBox(
                height: hei,
                width: MediaQuery.sizeOf(context).width,
                // padding: EdgeInsets.only(top: 10),
                // decoration: BoxDecoration(
                //   border: Border.all()
                // ),
                child: SizedBox(
                  height: hei - 20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const Gap(10),
                              _mainButtonSection(),
                              const Gap(20),
                              _favoritePostList(),
                              const Gap(20),
                              _testerList(),
                              // const Gap(20),
                              // _webServiceList(),
                            ],
                          ),
                        ),
                      ),
                      // CustomBottomBar(
                      //   currentIndex: 0,
                      //   onTap: (idx) {
                      //     setState(() {
                      //       _currentIdx = idx;
                      //     });
                      //   },
                      // )
                    ],
                  ),
                ))));
  }
  Widget _mainButtonSection() {
    return SizedBox(
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
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
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
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
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
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
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
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Center(
                    child: Text("커뮤니티"),
                  ))),
        ],
      ),
    );
  }

  Widget _favoritePostList() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text("조회 Top 10",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      Selector<PostProvider, List<PostEntity>>(
          selector: (context, provider) => provider.favoritePost,
          builder: (context, favoritePost, child) {
            return SizedBox(
                height: 230,
                width: MediaQuery.sizeOf(context).width,
                // padding: EdgeInsets.all(10),

                child: favoritePost.isEmpty ? const Center(child: Text("Top 10 게시글이 아직 없습니다.")) :
                ListView.separated(
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
                    itemCount: 10));
          })
    ]);
  }

  Widget _testerList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('테스터 모집',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              TextButton(
                  onPressed: () {
                    // context
                    //     .read<DataBloc>()
                    //     .add(RequestPostDataEvent(context, 'mobile', 1));
                    widget.onTap(1);
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Text("전체 보기"))
            ],
          ),
        ),
        Selector<PostProvider, List<PostEntity>>(
          selector: (context, provider) => provider.posts,
          builder: (context, post, child) => SizedBox(
              height: 150,
              width: MediaQuery.sizeOf(context).width,
              // padding: EdgeInsets.all(10),
              // decoration: BoxDecoration(
              //     border: Border.all()
              // ),
              child: post.isEmpty
                  ? const Center(child: Text("테스터 모집이 아직 없습니다."))
                  : ListView.separated(
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
                      child: Text("${post[idx].title}"),
                    );
                  },
                  separatorBuilder: (context, idx) => const Gap(10),
                  itemCount: post.length)),
        ),
      ],
    );
  }

  Widget _webServiceList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('웹 서비스',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              TextButton(
                  onPressed: () {
                    // context
                    //     .read<DataBloc>()
                    //     .add(RequestPostDataEvent(context, 'web', 1));
                    Get.to(() => const PostTesterPage());
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Text("더보기"))
            ],
          ),
        ),
        Selector<PostProvider, List<PostEntity>>(
          selector: (context, provider) => provider.posts,
          builder: (context, webPost, child) => SizedBox(
              height: 150,
              width: MediaQuery.sizeOf(context).width,
              // padding: EdgeInsets.all(10),
              // decoration: BoxDecoration(
              //     border: Border.all()
              // ),
              child: webPost.isEmpty
                  ? const Center(child: Text("웹 서비스 게시글이 아직 없습니다."))
                  : ListView.separated(
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
        ),
      ],
    );
  }
}
