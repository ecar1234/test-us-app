import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:test_us_app/services/theme_provider.dart';

class SideProjectsMainPage extends StatefulWidget {
  const SideProjectsMainPage({super.key});

  @override
  State<SideProjectsMainPage> createState() => _SideProjectsMainPageState();
}

class _SideProjectsMainPageState extends State<SideProjectsMainPage> {
  final ValueNotifier<int> _roleIdx = ValueNotifier(0);
  final userRole = ['전체', '프론트엔드', '백엔드', '기획/PM', '마케팅', '디자이너', '퍼블리셔', '기타'];

  @override
  void initState() {
    // TODO: 데이터 가져오는 bloc 작성.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei ?? MediaQuery.sizeOf(context).height - 120;
    final isDarkMode = context.read<ThemeProvider>().isDarkMode;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('사이드 프로젝트')),
        body: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: SizedBox(
            height: hei,
            child: Column(
              children: [
                // user role
                SizedBox(
                  height: 40,
                  child: Center(
                    child: SizedBox(
                      height: 30,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, idx) {
                          return ValueListenableBuilder<int>(
                            valueListenable: _roleIdx,
                            builder: (context, value, child) {
                              bool isSelected = (value == idx);
                              return GestureDetector(
                                onTap: () => _roleIdx.value = idx,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Theme.of(context).colorScheme.primary : (isDarkMode ? Colors.transparent : Colors.white),
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    userRole[idx],
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: isSelected ? Colors.white : Theme.of(context).textSelectionTheme.cursorColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        separatorBuilder: (context, idx) => const Gap(8),
                        itemCount: userRole.length,
                      ),
                    ),
                  ),
                ),
                // const Gap(10),
                // contents
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    itemBuilder: (context, idx) {
                      return Container(
                        height: 200,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: isDarkMode
                              ? null
                              : [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //title
                            Text(
                              '[팀원모집] 여행 일정을 관리하고 저장하는 여행 기록앱을 함께 만들어갈 팀원 모집',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 2,
                            ),
                            // role
                            //Todo: Wrap를 seletor로 감싸고 post.map으로 Container를 만든다.
                            Wrap(
                              direction: Axis.horizontal,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                Container(
                                  height: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [Text('프론드엔드 1/2')],
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [Text('프론드엔드 1/2')],
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [Text('프론드엔드 1/2')],
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [Text('프론드엔드 1/2')],
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    // border: Border.all(color: Colors.grey),
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [Text('프론드엔드 1/2', style: TextStyle(fontWeight: FontWeight.bold),)],
                                  ),
                                ),
                              ],
                            ),
                            // application user Images
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                appUserImages(),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.remove_red_eye_outlined, color: Colors.grey),
                                    const Gap(4),
                                    Text('43', style: TextStyle(color: Colors.grey),),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, idx) => const Gap(10),
                    itemCount: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          icon: Icon(Symbols.format_list_bulleted_add),
          label: Text('모집글 쓰기'),
        ),
      ),
    );
  }

  Widget appUserImages() {
    const double overlapOffset = 24.0;
    final double avatarSize = 34.0;
    return SizedBox(
      width: avatarSize + (4) * overlapOffset,
      height: avatarSize,
      child: Stack(
        children: List.generate(5, (idx) {
          return Positioned(
            left: idx * overlapOffset,
            child: Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // 이미지가 겹칠 때 시각적으로 분리하기 위한 하얀색 테두리
                border: Border.all(color: Colors.grey, width: 1.5),
                // image: DecorationImage(
                //   image: NetworkImage(imageUrls[index]),
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
