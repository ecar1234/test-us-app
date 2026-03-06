import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:test_us_app/services/revenue_cat_purchases/purchase_management.dart';

import '../../../services/theme_provider.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  final List<bool> _isPlanSelected = [false, false];
  int _isPeriodSelected = 0;
  Package? _selectedPackage;

  @override
  Widget build(BuildContext context) {
    final isDark = context.read<ThemeProvider>().isDarkMode;
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei ?? MediaQuery.sizeOf(context).height - 120;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // logo & title
                Column(
                  children: [
                    // logo icon
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 40),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20), child: Image.asset('assets/icons/app_icon.png')),
                    ),
                    const Gap(10),
                    //title
                    Text(
                      'GET TESTUS',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                // Free plan
                _compareDataTable(),
                _planCards(isDark),
                const Gap(20),
                // Button
                SizedBox(
                  width: MediaQuery.sizeOf(context).width - 40,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: _isPlanSelected.contains(true)
                          ? () async {
                              final plan = _isPlanSelected[0] ? 'Standard' : 'Premium';
                              final packages = await context.read<PurchasesManagements>().getOfferings(plan);

                              if (context.mounted) await _showBottomSheet(context, hei, plan, packages, isDark);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: Text('Plan 정보 확인',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _planCards(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  _selectedPackage = null;
                  _isPeriodSelected = 0;
                });
                if (_isPlanSelected[0]) {
                  setState(() {
                    _isPlanSelected[0] = false;
                  });
                  return;
                }
                setState(() {
                  _isPlanSelected[0] = true;
                  _isPlanSelected[1] = false;
                });
              },
              child: Container(
                  width: MediaQuery.sizeOf(context).width - 40,
                  height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color:
                            _isPlanSelected[0] ? (isDarkMode ? Colors.white : Colors.transparent) : Colors.blueAccent),
                    borderRadius: BorderRadius.circular(20),
                    color: _isPlanSelected[0] ? Colors.blueAccent : (isDarkMode ? Colors.grey.shade800 : Colors.white),
                  ),
                  child: Stack(children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Selector<PurchasesManagements, CustomerInfo?>(builder: (context, info, child) {
                        if (info != null &&
                            info.entitlements.all['Standard'] != null &&
                            info.entitlements.all['Standard']!.isActive) {
                          // todo: 이우 이용권 애용을 바탕으로 기능 추가하기..
                          // todo: 구매 후 entity로 변화해서 가지고 있는겍 좋을듯..
                          // todo: 구매 내역을 서버에 저장 여부 고민,, 그리고 앱 실행 시 구매 이력 적용 로직 고민 필요..
                          // todo: 구매 정리 후 사이트 프로젝트 게시판 기능 고민..

                          return Text(
                            '이용중',
                            style: TextStyle(
                                color: _isPlanSelected[0] ? Colors.white : Colors.grey.shade500,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      }, selector: (context, purchase) {
                        debugPrint('${purchase.customerInfo}');
                        return purchase.customerInfo;
                      }),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Standard',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: _isPlanSelected[0] ? Colors.white : Colors.grey.shade500)),
                          Text(
                            '2,000₩ / Mon',
                            style: TextStyle(
                                fontSize: 12, color: _isPlanSelected[0] ? Colors.white : Colors.grey.shade500),
                          ),
                        ],
                      ),
                    )
                  ])),
            ),
          ),
          const Gap(20),
          Flexible(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPackage = null;
                  _isPeriodSelected = 0;
                });
                if (_isPlanSelected[1]) {
                  setState(() {
                    _isPlanSelected[1] = false;
                  });
                  return;
                }
                setState(() {
                  _isPlanSelected[1] = true;
                  _isPlanSelected[0] = false;
                });
              },
              child: Container(
                  width: MediaQuery.sizeOf(context).width - 40,
                  height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: _isPlanSelected[1]
                            ? (isDarkMode ? Colors.white : Colors.transparent)
                            : Colors.amber.shade600),
                    borderRadius: BorderRadius.circular(20),
                    color:
                        _isPlanSelected[1] ? Colors.amber.shade600 : (isDarkMode ? Colors.grey.shade800 : Colors.white),
                  ),
                  child: Stack(children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Selector<PurchasesManagements, CustomerInfo?>(builder: (context, info, child) {
                        if (info != null &&
                            info.entitlements.all['Premium'] != null &&
                            info.entitlements.all['Premium']!.isActive) {
                          // todo: 여기에 표시되는 UI 고민,,, 그리고 기종 중앙 정렬 유지한 체로 표시.. stack???
                          // todo: 이우 이용권 애용을 바탕으로 기능 추가하기..
                          // todo: 구매 후 entity로 변화해서 가지고 있는겍 좋을듯..
                          // todo: 구매 내역을 서버에 저장 여부 고민,, 그리고 앱 실행 시 구매 이력 적용 로직 고민 필요..
                          // todo: 구매 정리 후 사이트 프로젝트 게시판 기능 고민..

                          return Text(
                            '이용중',
                            style: TextStyle(
                                color: _isPlanSelected[1] ? Colors.white : Colors.grey.shade500,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      }, selector: (context, purchase) {
                        return purchase.customerInfo;
                      }),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Premium',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: _isPlanSelected[1] ? Colors.white : Colors.grey.shade500)),
                          Text(
                            '4,500₩ / Mon',
                            style: TextStyle(
                                fontSize: 12, color: _isPlanSelected[1] ? Colors.white : Colors.grey.shade500),
                          ),
                        ],
                      ),
                    )
                  ])),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _showBottomSheet(
      BuildContext context, double hei, String plan, List<Package> packages, bool isDark) async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 60),
            child: Stack(
              children: [
                SizedBox(
                    height: hei * 0.8,
                    width: MediaQuery.sizeOf(context).width,
                    child: Column(
                      children: [
                        // tile
                        Container(
                          width: 80,
                          height: 80,
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20), child: Image.asset('assets/icons/app_icon.png')),
                        ),
                        const Gap(10),
                        //title
                        Text(
                          plan,
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const Gap(20),
                        if (packages.isNotEmpty) _planBuilder(packages),
                        //Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.8,
                              height: 50,
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (_selectedPackage == null && _isPeriodSelected == 0) {
                                      setState(() {
                                        _selectedPackage = packages[0];
                                      });
                                    }
                                    if (context
                                            .read<PurchasesManagements>()
                                            .customerInfo
                                            ?.entitlements
                                            .all
                                            .values
                                            .first
                                            .productPlanIdentifier ==
                                        _selectedPackage!.storeProduct.identifier.split(':')[1]) {
                                      Get.defaultDialog(
                                        title: '알림',
                                        middleText: '이미 구매한 상품입니다.',
                                        textConfirm: '확인',
                                        confirmTextColor: Colors.white,
                                        onConfirm: () {
                                          Get.back();
                                        },
                                      );
                                      return;
                                    }

                                    // debugPrint('[package] ${_selectedPackage!.storeProduct.identifier}');
                                    context.read<PurchasesManagements>().purchase(_selectedPackage!,
                                        isChangePackage: context
                                            .read<PurchasesManagements>()
                                            .customerInfo
                                            ?.entitlements
                                            .all
                                            .values
                                            .first
                                            .isActive);
                                    Get.back();
                                  },
                                  style:
                                      ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
                                  child: Text('구매하기', style: TextStyle(color: Colors.white))),
                            ),
                          ],
                        )
                      ],
                    )),
                Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.shade300,
                            ),
                            child: Icon(Symbols.close, size: 20, color: Colors.grey.shade600))))
              ],
            ),
          );
        });
  }

  Widget _compareDataTable() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: DataTable(
          border: TableBorder.symmetric(inside: BorderSide(color: Colors.grey.shade400)),
          columnSpacing: 30,
          columns: const <DataColumn>[
            DataColumn(label: Text('')),
            DataColumn(
                label: Text(
              'Free',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              'Standard',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            )),
            DataColumn(
                label: Text(
              'Premium',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.amber),
            )),
          ],
          rows: const <DataRow>[
            DataRow(cells: [
              DataCell(Center(
                  child: Text(
                '테스트',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ))),
              DataCell(Center(child: Text('1개'))),
              DataCell(Center(child: Text('2개'))),
              DataCell(Center(child: Text('4개'))),
            ]),
            DataRow(cells: [
              DataCell(Center(
                  child: Text(
                '홍보',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ))),
              DataCell(Center(child: Text('1개'))),
              DataCell(Center(child: Text('2개'))),
              DataCell(Center(child: Text('무제한'))),
            ]),
            DataRow(cells: [
              DataCell(Center(
                  child: Text(
                '이미지',
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
    );
  }

  Widget _planBuilder(
    List<Package> packages,
  ) {
    return Expanded(
      child: StatefulBuilder(
        builder: (context, setState) => ListView.separated(
            shrinkWrap: false,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, idx) {
              final info = context.read<PurchasesManagements>().customerInfo;
              final data = _getStandardData(packages[idx].storeProduct);
              bool isUsed = false;
              if (info != null) {
                if (packages[idx].storeProduct.identifier.split(':')[1] ==
                    info.entitlements.all[packages[idx].storeProduct.title.split(' ')[0]]?.productPlanIdentifier) {
                  if (info.entitlements.all[packages[idx].storeProduct.title.split(' ')[0]]!.isActive) {
                    isUsed = true;
                  }
                }
                // print(packages[idx].storeProduct.identifier.split(':')[1]);
                // print(info.entitlements.all[packages[idx].storeProduct.title.split(' ')[0]]?.productPlanIdentifier);
              }

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _isPeriodSelected = idx;
                    _selectedPackage = packages[idx];
                  });
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width - 40,
                  height: 80,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: _isPeriodSelected == idx
                              ? (data['title'].contains('Premium') ? Colors.amber : Colors.blueAccent)
                              : Colors.grey.shade400,
                          width: _isPeriodSelected == idx ? 2 : 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Flexible(
                          flex: 7,
                          child: SizedBox(
                            width: (MediaQuery.sizeOf(context).width - 60) * 0.7,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      data['title'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: _isPeriodSelected == idx
                                              ? Theme.of(context).colorScheme.onSurface
                                              : Colors.grey.shade700),
                                    ),
                                    const Gap(10),
                                    if (data['discount'] != '' && _isPeriodSelected == idx)
                                      Container(
                                          height: 25,
                                          padding: EdgeInsets.symmetric(horizontal: 8),
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey.shade400),
                                              borderRadius: BorderRadius.circular(10),
                                              color:
                                                  data['title'].contains('Premium') ? Colors.amber : Colors.blueAccent),
                                          child: Center(
                                              child: Text(
                                            'SAVE ${data['discount']}',
                                            style: TextStyle(
                                                color: data['title'].contains('Premium') ? Colors.black : Colors.white,
                                                fontSize: 12),
                                          )))
                                  ],
                                ),
                                if (isUsed)
                                  Row(
                                    children: [
                                      Text(data['perMonth'],
                                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                                      const Gap(10),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey.shade400),
                                            borderRadius: BorderRadius.circular(10)),
                                        child: Text('이용중', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                                      )
                                    ],
                                  ),
                              ],
                            ),
                          )),
                      Flexible(
                          flex: 3,
                          child: SizedBox(
                            width: (MediaQuery.sizeOf(context).width - 60) * 0.3,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    data['price'],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: _isPeriodSelected == idx
                                            ? Theme.of(context).colorScheme.onSurface
                                            : Colors.grey.shade700),
                                  ),
                                ]),
                          ))
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, idx) => const Gap(10),
            itemCount: packages.length),
      ),
    );
  }

  Map<String, dynamic> _getStandardData(StoreProduct data) {
    Map<String, dynamic> res = {};
    switch (data.subscriptionPeriod) {
      case 'P1M':
        res['title'] = '${data.title.split(' ')[0]} 1개월 구독';
        res['price'] = data.priceString;
        res['discount'] = '';
        res['perMonth'] = '${data.pricePerMonthString}/ Month';
        break;
      case 'P3M':
        res['title'] = '${data.title.split(' ')[0]} 3개월 구독';
        res['price'] = data.priceString;
        res['discount'] = '20%';
        res['perMonth'] = '${data.pricePerMonthString} / Month';
        break;
      case 'P6M':
        res['title'] = '${data.title.split(' ')[0]} 6개월 구독';
        res['price'] = data.priceString;
        res['discount'] = '25%';
        res['perMonth'] = '${data.pricePerMonthString} / Month';
        break;
      case 'P1Y':
        res['title'] = '${data.title.split(' ')[0]} 1년 구독';
        res['price'] = data.priceString;
        res['discount'] = '30%';
        res['perMonth'] = '${data.pricePerMonthString} / Month';
    }

    return res;
  }
}
