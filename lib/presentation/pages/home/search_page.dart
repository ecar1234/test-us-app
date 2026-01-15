import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:test_us_app/data/models/application/application_model.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/base_post_bloc/base_post_bloc.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/base_post_bloc/base_post_event.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/base_post_bloc/base_post_state.dart';
import 'package:test_us_app/utils/type_conversion_util.dart';

import '../../../domain/entities/recruit_post_entity.dart';
import '../../../services/common_height_provider.dart';
import '../../../services/theme_provider.dart';
import '../post/promotion_post_pages/promotion_post_detail_page.dart';
import '../post/tester_post_pages/recruit_post_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  List<dynamic> samples = [];
  List<dynamic> searchResults = [];

  int _selectedIndex = 0;

  void _onTextChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(seconds: 1), () {
      final keyword = value.trim();

      setState(() {
        if (keyword.isEmpty) {
          searchResults.clear();
          return;
        }
        final currentIdx = ++_selectedIndex;
        if (currentIdx != _selectedIndex) return;

        // todo : BasePostBloc에서 데이터 요청 후 검색 로직 구현
        try {
          searchResults.clear();
          context.read<BasePostBloc>().add(SearchPostEvent(keyword));
        } catch (e) {
          if (currentIdx != _selectedIndex) return;
        }
      });

      debugPrint('최종 입력값: $keyword');
    });
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   samples.addAll(context.read<BasePostProvider>().recruitPosts as List<dynamic>);
  //   samples.addAll(context.read<BasePostProvider>().promotionPosts as List<dynamic>);
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
    _debounce?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei!;
    final isDarkMode = context.read<ThemeProvider>().isDarkMode;
    return Scaffold(
        body: BlocListener<BasePostBloc, BasePostState>(
      listener: (context, state) {
        if (state is GetSearchPostState) {
          setState(() {
            searchResults.clear();
            searchResults.addAll(state.recruit!);
            searchResults.addAll(state.promotion!);
          });
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          height: hei,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              _searchBar(),
              if (_searchController.text.isNotEmpty)
                _searchList(hei, isDarkMode)
              else
                SizedBox(
                  height: hei - 120,
                  child: Center(
                    child: Text.rich(
                      TextSpan(text: 'TESTES', children: [
                        TextSpan(
                            text: ' 의 게시물을 검색 할 수 있어요.',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: isDarkMode ? Colors.white : Colors.grey.shade800)),
                      ]),
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    ));
  }

  Widget _searchBar() {
    return SizedBox(
        height: 50,
        child: TextField(
          controller: _searchController,
          onChanged: _onTextChanged,
          decoration: InputDecoration(
            hintText: '검색어를 입력해주세요.',
          )
        ));
  }

  Widget _searchList(double hei, bool isDarkMode) {
    if (searchResults.isEmpty) {
      return SizedBox(
        height: hei - 120,
        child: Center(
          child: Text(
            '검색 결과가 없습니다.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    return ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.symmetric(vertical: 20),
        itemBuilder: (context, idx) {
          final isRecruit = searchResults[idx] is RecruitPostEntity;

          final bgColor = isRecruit ? const Color(0xFFFFE0B2) : const Color(0xFFE3F2FD);

          final textColor = isRecruit ? const Color(0xFFBF360C) : const Color(0xFF0D47A1);
          return Stack(
            children: [
              GestureDetector(
                onTap: () {
                  if (isRecruit) {
                    Get.to(() => RecruitPostDetailPage(postId: searchResults[idx].id!));
                  } else if (searchResults[idx].postType == 'promotion') {
                    Get.to(() => PromotionPostDetailPage(postId: searchResults[idx].id!));
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: isDarkMode
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.grey.withAlpha(84),
                                spreadRadius: 2,
                                blurRadius: 9,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ]),
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Row(
                      children: [
                        Flexible(
                            flex: 3,
                            child: SizedBox(
                                width: (MediaQuery.sizeOf(context).width - 50) * 0.3,
                                height: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: searchResults[idx].images![0].url!,
                                    fit: BoxFit.cover,
                                  ),
                                ))),
                        const Gap(8),
                        Flexible(
                          flex: 7,
                          child: SizedBox(
                            width: constraints.maxWidth * 0.7,
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(
                                searchResults[idx].title,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                searchResults[idx].subtitle,
                                style: TextStyle(fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  Text(searchResults[idx].platform == ApplicationPlatform.web ? 'WEB' : 'MOBILE'),
                                  if (searchResults[idx].platform == ApplicationPlatform.mobile)
                                    Text(' (${TypeConversionUtil().getPostOs(searchResults[idx].mobileOs)})'),
                                ],
                              ),
                              Text(TypeConversionUtil().postCategoryToString(searchResults[idx].category))
                            ]),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
              Positioned(
                // top: 5,
                top: 5,
                right: 5,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                    color: bgColor,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    isRecruit ? "모집" : "홍보",
                    style: TextStyle(fontSize: 14, color: textColor),
                  ),
                ),
              )
            ],
          );
        },
        separatorBuilder: (context, idx) => const Gap(10),
        itemCount: searchResults.length);
  }
}
