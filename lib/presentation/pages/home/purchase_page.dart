import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:test_us_app/domain/entities/purchase_entity.dart';
import 'package:test_us_app/presentation/bloc/purchase_bloc/purchase_event.dart';
import 'package:test_us_app/presentation/bloc/purchase_bloc/purchase_state.dart';
import 'package:test_us_app/presentation/components/one_action_dialog.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:test_us_app/services/revenue_cat_purchases/purchase_management.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../services/theme_provider.dart';
import '../../bloc/purchase_bloc/purchase_bloc.dart';

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
          child: BlocListener<PurchaseBloc, PurchaseState>(
            // todo: dialog를 컴포넌트 화시켜 / 원버튼, 투버튼.
            listener: (context, state) async {
              if (state is GetOfferingCompletedState) {
                if (state.packages!.isNotEmpty) {
                  context.read<PurchasesManagements>().getOfferings(state.packages ?? []);
                  setState(() {
                    _selectedPackage = state.packages![0];
                  });
                  return;
                }
              } else if (state is PurchaseCompletedState) {
                context.read<PurchasesManagements>().purchase(state.entity);
                await showDialog(
                    context: context,
                    builder: (context) => Dialog(
                        child: OneActionDialog(
                            title: '구독 시작',
                            contents1: '구독이 시작 되었습니다.',
                            contents2: '이제 모든 ${state.entity.plan} 기능을 마음껏 이용해 보세요.',
                            buttonText: '확인',
                            onPressed: () => Get.back())));
                return;
              } else if (state is PurchaseUpdateCompletedState) {
                context.read<PurchasesManagements>().purchase(state.entity);
                String comment = '';
                if (state.grade == -1) {
                  comment = 'Premium으로 업그레이드되었습니다!-지금 즉시 모든 프리미엄 혜택이 적용됩니다.';
                } else if (state.grade == 1) {
                  comment = '플랜 변경 예약이 완료되었습니다.-현재 Premium 혜택은 이번 주기가 끝나는 ${state.entity.expireDate}까지 유지됩니다.';
                } else {
                  comment = '${state.entity.plan}의 구독 기간이 성공적으로 변경되었습니다.-다음 갱신일부터 변경된 기간으로 결제가 진행됩니다.';
                }
                await showDialog(
                    context: context,
                    builder: (context) => Dialog(
                        child: OneActionDialog(
                            title: '구독 변경 성공',
                            contents1: comment.split('-')[0],
                            contents2: comment.split('-')[1],
                            buttonText: '확인',
                            onPressed: () => Get.back())));
                return;
              }
            },
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
                                // showDialog(context: context, builder: (context) => Dialog(
                                //   child: OneActionDialog(
                                //       title: "구독 알림",
                                //       contents1: '구독이 시작 되었습니다.',
                                //       contents2: '이제 모든 플랜 기능을 마음껏 이용해 보세요.',
                                //       buttonText: '확인',
                                //       buttonWidth: 100,
                                //       onPressed: () => Get.back() ),
                                // ));
                                final plan = _isPlanSelected[0] ? 'Standard' : 'Premium';
                                context.read<PurchaseBloc>().add(PurchaseOfferings(plan));

                                if (context.mounted) await _showBottomSheet(context, hei, plan, isDark);
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
                      child: Selector<PurchasesManagements, PurchaseEntity?>(builder: (context, subscribedItem, child) {
                        if (subscribedItem != null && subscribedItem.isActive! && subscribedItem.plan == 'standard') {
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
                        return purchase.subscribedItem;
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
                      child: Selector<PurchasesManagements, PurchaseEntity?>(builder: (context, subscribedItem, child) {
                        if (subscribedItem != null && subscribedItem.isActive! && subscribedItem.plan == 'premium') {
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
                        return purchase.subscribedItem;
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

  Future<void> _showBottomSheet(BuildContext context, double hei, String plan, bool isDark) async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
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
                        _planBuilder(plan),
                        //Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.8,
                              height: 50,
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (context.read<UserProvider>().isLogged == false ||
                                        context.read<UserProvider>().isLogged == null) {
                                      Get.defaultDialog(
                                          title: '알림',
                                          middleText: '로그인 후 이용해주세요.',
                                          textConfirm: '확인',
                                          confirmTextColor: Colors.white,
                                          onConfirm: () {
                                            Get.back();
                                          });
                                      return;
                                    }

                                    final info = context.read<PurchasesManagements>().subscribedItem;
                                    bool isChange = false;

                                    if (info != null &&
                                        info.planId == _selectedPackage!.storeProduct.identifier.split(':')[1]) {
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
                                    if (info != null && info.isActive == true) {
                                      isChange = true;
                                    }

                                    if (isChange) {
                                      context.read<PurchaseBloc>().add(RequestUpdatePurchase(_selectedPackage!, info!));
                                    } else {
                                      context.read<PurchaseBloc>().add(RequestNewPurchase(_selectedPackage!));
                                    }
                                    Get.back();
                                  },
                                  style:
                                      ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
                                  child: Text('구매하기', style: TextStyle(color: Colors.white))),
                            ),
                          ],
                        ),
                        const Divider(
                          height: 30,
                        ),
                        // 약관, 개인정보 처리방침
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 30,
                                child: TextButton(
                                    onPressed: () {
                                      launchUrl(Uri.parse('https://readygoprivate.imweb.me/?mode=policy'));
                                    },
                                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                    child: Text("이용약관")),
                              ),
                              SizedBox(
                                height: 30,
                                child: TextButton(
                                    onPressed: () {
                                      launchUrl(Uri.parse('https://readygoprivate.imweb.me/?mode=privacy'));
                                    },
                                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                                    child: Text("개인정보 처리 방침")),
                              )
                            ],
                          ),
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
                label: Center(
              child: Text(
                'Free',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            )),
            DataColumn(
                label: Center(
              child: Text(
                'Standard',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
            )),
            DataColumn(
                label: Center(
              child: Text(
                'Premium',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.amber),
              ),
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
              //TODO: 자간 줄이거나 ... 어쨋든 방법이 필요함.
              DataCell(Center(child: Text('4장 / 25Mb'))),
              DataCell(Center(child: Text('6장 / 40Mb'))),
              DataCell(Center(child: Text('8장 / 80Mb'))),
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

  Widget _planBuilder(String plan) {
    return Expanded(
      child: Selector<PurchasesManagements, List<Package>>(
        selector: (context, provider) {
          return provider.packages ?? [];
        },
        builder: (context, packages, child) => StatefulBuilder(
          builder: (context, setState) => ListView.separated(
              shrinkWrap: false,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, idx) {
                final info = context.read<PurchasesManagements>().subscribedItem;
                final data = _getPackageData(packages[idx].storeProduct);
                bool isUsed = false;
                if (info != null) {
                  if (packages[idx].storeProduct.identifier.split(':')[1] == info.planId! && info.isActive!) {
                    isUsed = true;
                  }
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
                                ? (plan == 'Premium' ? Colors.amber : Colors.blueAccent)
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
                                                color: Colors.red.shade300),
                                            child: Center(
                                                child: Text(
                                              'SAVE ${data['discount']}',
                                              style: TextStyle(color: Colors.white, fontSize: 12),
                                            )))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(data['perMonth'],
                                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                                      const Gap(10),
                                      if (isUsed)
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey.shade400),
                                            borderRadius: BorderRadius.circular(10),
                                            color: plan == 'Standard' ? Colors.blueAccent : Colors.amber,
                                          ),
                                          child: Text('이용중', style: TextStyle(fontSize: 12, color: Colors.white)),
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
      ),
    );
  }

  Map<String, dynamic> _getPackageData(StoreProduct data) {
    Map<String, dynamic> res = {};
    switch (data.subscriptionPeriod) {
      case 'P1M':
        res['title'] = '1개월 구독';
        res['price'] = data.priceString;
        res['discount'] = '';
        res['perMonth'] = '${data.pricePerMonthString}/ Month';
        break;
      case 'P3M':
        res['title'] = '3개월 구독';
        res['price'] = data.priceString;
        res['discount'] = '20%';
        res['perMonth'] = '${data.pricePerMonthString} / Month';
        break;
      case 'P6M':
        res['title'] = '6개월 구독';
        res['price'] = data.priceString;
        res['discount'] = '25%';
        res['perMonth'] = '${data.pricePerMonthString} / Month';
        break;
      case 'P1Y':
        res['title'] = '1년 구독';
        res['price'] = data.priceString;
        res['discount'] = '30%';
        res['perMonth'] = '${data.pricePerMonthString} / Month';
    }

    return res;
  }
}
