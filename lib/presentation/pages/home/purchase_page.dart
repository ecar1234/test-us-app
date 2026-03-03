import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../services/common_height_provider.dart';
import '../../../services/theme_provider.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  final List<ValueNotifier<bool>> _isOpened = List.generate(2, (_) => ValueNotifier(false));

  @override
  Widget build(BuildContext context) {
    final isDark = context.read<ThemeProvider>().isDarkMode;
    return SafeArea(
      child: Scaffold(
        body: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _freePlan(isDark),
                const Gap(10),
                _planBuilder(context, isDark),
                const Gap(10),
              ],
            )),
      ),
    );
  }

  Widget _freePlan(bool isDark) {
    return Container(
      width: MediaQuery.sizeOf(context).width - 60,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
          color: isDark ? Colors.grey.shade800 : Colors.white,
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: 3,
                    offset: Offset(2, 3),
                  )
                ]),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: isDark ? Colors.grey : Colors.grey.shade300,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Free (기본 기능)',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, shadows: [
                      Shadow(
                        color: Colors.grey.shade500,
                        blurRadius: 3,
                        offset: Offset(1, 3),
                      )
                    ])),
                SizedBox(
                  width: (MediaQuery.sizeOf(context).width - 40) * 0.6,
                  child: Divider(
                    color: isDark ? Colors.grey.shade600 : Colors.grey,
                  ),
                ),
                Text(
                  '0₩ / Month',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, shadows: [
                    Shadow(
                      color: Colors.grey.shade500,
                      blurRadius: 3,
                      offset: Offset(1, 3),
                    )
                  ]),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('✔️ 테스트 진행 1개, 홍보 게시 1개'),
                Text('✔️ 사이드 프로젝트 1개'),
                Text('✔️ 게시글 끌어올리기 1회'),
                Text('✔️ 이미지 등록 최대 4장'),
                Text('✔️ 게시글 게시기간 7일'),
                Text('✔️ 채팅보관 테스트 종료 후 3일'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _planBuilder(BuildContext context, bool isDark) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei ?? MediaQuery.sizeOf(context).height - 120;
    return Accordion(
        paddingBetweenClosedSections: 20, // 0으로 주면 딱 붙고, 값을 키우면 멀어집니다.
        paddingBetweenOpenSections: 20,
        children: [
          AccordionSection(
            isOpen: true,
            onCloseSection: () => _isOpened[0].value = false,
            onOpenSection: () => _isOpened[0].value = true,
            rightIcon: const SizedBox.shrink(),
            headerPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            headerBackgroundColor: Colors.blueAccent,
            header: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Standard',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, shadows: [
                        Shadow(
                          color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                          blurRadius: 3,
                          offset: Offset(1, 3),
                        )
                      ]),
                    ),
                    SizedBox(
                      width: (MediaQuery.sizeOf(context).width - 80) * 0.6,
                      child: Divider(
                        color: isDark ? Colors.grey.shade600 : Colors.grey,
                      ),
                    ),
                    Text(
                      '2,000₩ / Month',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, shadows: [
                        Shadow(
                          color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                          blurRadius: 3,
                          offset: Offset(1, 2),
                        )
                      ]),
                    )
                  ],
                )),
            content: Container(
              width: double.infinity,
              color: isDark ? Colors.grey.shade800 : Colors.white,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('✔️ Free Plan의 모든 기능'),
                      const Text('✔️ 테스트 진행 2개, 홍보 게시 2개'),
                      const Text('✔️ 게시글 끌어올리기 각 1 회'),
                      const Text('✔️ 이미지 등록 최대 6장'),
                      const Text('✔️ 게시글 게시기간 14일'),
                      const Text('✔️ 채팅보관 테스트 종료 후 10일'),
                    ],
                  ),
                  const Gap(20),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                        onPressed: () async {
                          await _showBottomSheet(context, hei, 'Standard', isDark);
                        },
                        child: const Text('이용권 구매')),
                  )
                ],
              ),
            ),
            contentHorizontalPadding: 0,
            contentVerticalPadding: 0,
            contentBorderColor: Colors.blueAccent,
          ),
          AccordionSection(
            isOpen: false,
            onCloseSection: () => _isOpened[1].value = false,
            onOpenSection: () => _isOpened[1].value = true,
            rightIcon: const SizedBox.shrink(),
            headerPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            headerBackgroundColor: Colors.amber,
            header: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Premium',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, shadows: [
                        Shadow(
                          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                          blurRadius: 3,
                          offset: Offset(1, 3),
                        )
                      ]),
                    ),
                    SizedBox(
                      width: (MediaQuery.sizeOf(context).width - 80) * 0.6,
                      child: Divider(
                        color: isDark ? Colors.grey.shade600 : Colors.grey,
                      ),
                    ),
                    Text(
                      '4,500₩ / Month',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, shadows: [
                        Shadow(
                          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                          blurRadius: 3,
                          offset: Offset(1, 2),
                        )
                      ]),
                    )
                  ],
                )),
            content: Container(
              width: double.infinity,
              color: isDark ? Colors.grey.shade800 : Colors.white,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('✔️ 테스트 진행 2개, 홍보 게시 2개'),
                      const Text('✔️ 게시글 끌어올리기 각 4회'),
                      const Text('✔️ 이미지 등록 최대 8장'),
                      const Text('✔️ 게시글 게시기간 30일'),
                      const Text('✔️ 채팅보관 무제한'),
                    ],
                  ),
                  const Gap(20),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                        onPressed: () {
                          _showBottomSheet(context, hei, 'Premium', isDark);
                        },
                        child: const Text('이용권 구매')),
                  )
                ],
              ),
            ),
            contentHorizontalPadding: 0,
            contentVerticalPadding: 0,
            contentBorderColor: Colors.amber,
          ),
        ]);
  }

  Future<void> _showBottomSheet(BuildContext context, double hei, String plan, bool isDark) async {
    final standardTitleColor = plan == 'Standard' ? Colors.blueAccent : Theme.of(context).colorScheme.onSurface;
    final premiumTitleColor = plan == 'Premium' ? Colors.amber : Theme.of(context).colorScheme.onSurface;
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SizedBox(
              height: hei * 0.9,
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                children: [
                  // tile
                  Container(
                      width: double.infinity,
                      height: 100,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        color: plan == 'Standard' ? Colors.blueAccent : Colors.amber,
                      ),
                      child: Center(
                          child: Text('$plan 구매',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, shadows: [
                                Shadow(
                                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
                                  blurRadius: 3,
                                  offset: Offset(1, 3),
                                )
                              ])))),
                  const Gap(10),
                  // table
                  DataTable(
                      border: TableBorder.symmetric(inside: BorderSide(color: Colors.grey.shade400)),
                      columns: <DataColumn>[
                        const DataColumn(label: Text('')),
                        const DataColumn(
                            label: Text(
                          'Free',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                          'Standard',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: standardTitleColor),
                        )),
                        DataColumn(
                            label: Text(
                          'Premium',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: premiumTitleColor),
                        )),
                      ],
                      rows: const <DataRow>[
                        DataRow(cells: [
                          DataCell(Center(
                              child: Text(
                            '테스트 진행',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ))),
                          DataCell(Center(child: Text('1개'))),
                          DataCell(Center(child: Text('2개'))),
                          DataCell(Center(child: Text('4개'))),
                        ]),
                        DataRow(cells: [
                          DataCell(Center(
                              child: Text(
                            '홍보 게시',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ))),
                          DataCell(Center(child: Text('1개'))),
                          DataCell(Center(child: Text('2개'))),
                          DataCell(Center(child: Text('무제한'))),
                        ]),
                        DataRow(cells: [
                          DataCell(Center(
                              child: Text(
                            '게시글 이미지',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ))),
                          DataCell(Center(child: Text('4장'))),
                          DataCell(Center(child: Text('8장'))),
                          DataCell(Center(child: Text('8장'))),
                        ]),
                        DataRow(cells: [
                          DataCell(Center(
                              child: Text(
                            '게시기간',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ))),
                          DataCell(Center(child: Text('7일'))),
                          DataCell(Center(child: Text('14일'))),
                          DataCell(Center(child: Text('30일'))),
                        ]),
                        DataRow(cells: [
                          DataCell(Center(
                              child: Text(
                            '메시지 보관',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ))),
                          DataCell(Center(child: Text('3일'))),
                          DataCell(Center(child: Text('10일'))),
                          DataCell(Center(child: Text('무제한'))),
                        ]),
                        DataRow(cells: [
                          DataCell(Center(
                              child: Text(
                            '끌어올리기',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ))),
                          DataCell(Center(child: Text('1회'))),
                          DataCell(Center(child: Text('2회'))),
                          DataCell(Center(child: Text('4회'))),
                        ]),
                        DataRow(cells: [
                          DataCell(Center(
                              child: Text(
                            '단체 메시지',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ))),
                          DataCell(Center(child: Text('❌'))),
                          DataCell(Center(child: Text('2개'))),
                          DataCell(Center(child: Text('무제한'))),
                        ]),
                      ]),
                  const Gap(30),
                  // drop down menu
                  if (plan == 'Standard') _standardMenu() else _premiumMenu(),
                  const Gap(30),
                  //Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 3,
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.3,
                          height: 50,
                          child: OutlinedButton(
                              onPressed: () {
                                Get.back();
                              },
                              style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Theme.of(context).colorScheme.primary),
                                      borderRadius: BorderRadius.circular(10))),
                              child: Text('취소')),
                        ),
                      ),
                      const Gap(20),
                      Flexible(
                        flex: 6,
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.6,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Theme.of(context).colorScheme.primary),
                              child: Text('구매하기', style: TextStyle(color: Colors.white))),
                        ),
                      ),
                    ],
                  )
                ],
              ));
        });
  }

  Widget _standardMenu() {
    return SizedBox(
      child: DropdownMenu(
          initialSelection: '',
          width: MediaQuery.sizeOf(context).width * 0.6,
          menuHeight: 200,
          onSelected: (String? value) {
            debugPrint(value);
          },
          dropdownMenuEntries: [
            DropdownMenuEntry(value: '', label: '이용권 선택'),
            DropdownMenuEntry(value: 'standard1m', label: '1개월 / 2,000₩'),
            DropdownMenuEntry(value: 'standard3m', label: '3개월 / 4,800₩(-20%)'),
            DropdownMenuEntry(value: 'standard6m', label: '6개월 / 9,000₩(-25%)'),
            DropdownMenuEntry(value: 'standard12m', label: '12개월 / 16,800₩(-30%)'),
          ]),
    );
  }

  Widget _premiumMenu() {
    return SizedBox(
      child: DropdownMenu(
          initialSelection: '',
          width: MediaQuery.sizeOf(context).width * 0.6,
          menuHeight: 200,
          onSelected: (String? value) {
            debugPrint(value);
          },
          dropdownMenuEntries: [
            DropdownMenuEntry(value: '', label: '이용권 선택'),
            DropdownMenuEntry(value: 'premium1m', label: '1개월 / 4,500₩'),
            DropdownMenuEntry(value: 'premium3m', label: '3개월 / 10,800₩(-20%)'),
            DropdownMenuEntry(value: 'premium6m', label: '6개월 / 20,000₩(-25%)'),
            DropdownMenuEntry(value: 'premium12m', label: '12개월 / 37,800₩(-30%)'),
          ]),
    );
  }
}
