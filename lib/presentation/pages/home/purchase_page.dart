import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/domain/entities/purchase_entity.dart';
import 'package:test_us_app/presentation/bloc/purchase_bloc/purchase_event.dart';
import 'package:test_us_app/presentation/bloc/purchase_bloc/purchase_state.dart';
import 'package:test_us_app/presentation/components/one_action_dialog.dart';
import 'package:test_us_app/presentation/components/simple_text_toast_box.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:test_us_app/presentation/provider/purchase_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/entities/product_entity.dart';
import '../../../services/theme_provider.dart';
import '../../bloc/purchase_bloc/purchase_bloc.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  final List<bool> _isPlanSelected = [false, false];
  int _isPeriodSelected = -1;
  ProductEntity? _selectedProduct;

  @override
  Widget build(BuildContext context) {
    final isDark = context.read<ThemeProvider>().isDarkMode;
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei ?? MediaQuery.sizeOf(context).height - 120;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: MultiBlocListener(
            // todo: dialog를 컴포넌트 화시켜 / 원버튼, 투버튼.
            listeners: [
              BlocListener<PurchaseBloc, PurchaseState>(listener: (context, state) async {
                if (state is PurchaseUpdateCompletedState) {
                  BotToast.showCustomNotification(
                      toastBuilder: (context) => SimpleTextToastBox(text: '구독 업데이트 성공'),
                      duration: Duration(seconds: 3),
                      align: Alignment.bottomCenter
                  );
                } else if (state is PurchaseCompletedByServerState) {
                  // 구매 완료 후 서버에 저장 후 받은 데이터 저장하기
                  context.read<PurchaseProvider>().updatePurchaseByServer(state.entity);
                  BotToast.showCustomNotification(
                      toastBuilder: (context) => SimpleTextToastBox(text: '구독이 시작 되었습니다.'),
                      duration: Duration(seconds: 3),
                      align: Alignment.bottomCenter
                  );
                } else if (state.state == PurchaseProgressState.error) {
                  debugPrint('[Purchase] ${state.message}');
                  Get.snackbar('알림', state.message?? '구매 검증에 실패 했습니다.');
                  context.read<PurchaseBloc>().add(PurchaseStateInitEvent());
                  return;
                } else if(state.state == PurchaseProgressState.failed) {
                  debugPrint('[Purchase] ${state.message}');
                  Get.snackbar('알림', state.message?? '알 수 없는 오류 발생. 다시 시도해 주세요.');
                  return;
                }
              }),
              // aos 구독 업데이트 전 restore 상태
              BlocListener<PurchaseBloc, PurchaseState>(
                listener: (context, state) {
                  if (state is PurchaseRestoreCompletedState && Platform.isAndroid) {
                    context.read<PurchaseBloc>().add(RequestAosUpdatePurchase(
                        product: _selectedProduct!.originProduct,
                        productId: _selectedProduct!.id!,
                        old: state.details,
                        userId: context.read<UserProvider>().user!.id!
                    ));
                  }
                },
                listenWhen: (previous, current) => previous is UpdateLoadingState, // 업데이트 전 restore 상태
              ),
              // 구매 완료 상태
              BlocListener<PurchaseBloc, PurchaseState>(
                listener: (context, state) async {
                  if (state is PurchaseCompletedState || state is PurchaseRestoreCompletedState) {
                    final token = context.read<UserProvider>().token ?? '';
                    final userId = context.read<UserProvider>().user!.id ?? '';
                    _isPeriodSelected = -1;

                    context.read<PurchaseBloc>().add(
                      VerificationPurchase(
                          token: token,
                          userId: userId,
                          details: (state as dynamic).details // 또는 공통 인터페이스 사용
                      ),
                    );
                  }
                },
                listenWhen: (previous, current) => previous is PurchasePendingState, // 구매 요처 후 대기 상태
              )
            ],

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
                                final plan = _isPlanSelected[0] ? 'Standard' : 'Premium';
                                if (context.read<PurchaseProvider>().products.isEmpty) {
                                  context.read<PurchaseBloc>().add(PurchaseOfferings());
                                }

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
                // setState(() {
                //   // _selectedPackage = null;
                //   _isPeriodSelected = 0;
                // });
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
                      child: Selector<PurchaseProvider, PurchaseEntity?>(builder: (context, subscribedItem, child) {
                        if (subscribedItem != null && subscribedItem.isActive! && subscribedItem.plan == 'standard') {
                          return Text(
                            '구독 중',
                            style: TextStyle(
                                color: _isPlanSelected[0] ? Colors.white : Colors.grey.shade500,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      }, selector: (context, provider) {
                        return provider.subscribedList
                            .firstWhereOrNull((e) => e.isActive != null && e.isActive! && e.plan == 'standard');
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
                // setState(() {
                //   // _selectedPackage = null;
                //   _isPeriodSelected = 0;
                // });
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
                      child: Selector<PurchaseProvider, PurchaseEntity?>(builder: (context, subscribedItem, child) {
                        if (subscribedItem != null && subscribedItem.isActive! && subscribedItem.plan == 'premium') {
                          return Text(
                            '구독 중',
                            style: TextStyle(
                                color: _isPlanSelected[1] ? Colors.white : Colors.grey.shade500,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      }, selector: (context, provider) {
                        return provider.subscribedList
                            .firstWhereOrNull((e) => e.isActive != null && e.isActive! && e.plan == 'premium');
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
          return BlocSelector<PurchaseBloc, PurchaseState, bool>(selector: (state) {
            return state.state == PurchaseProgressState.loading || state is UpdateLoadingState;
          }, builder: (context, isLoading) {
            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return StatefulBuilder(
              builder: (context, setState) => Padding(
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
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset('assets/icons/app_icon.png')),
                            ),
                            const Gap(10),
                            //title
                            Text(
                              plan,
                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            const Gap(10),
                            _planBuilder(plan, setState),
                            const Gap(10),
                            //Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * 0.8,
                                  height: 50,
                                  child: ElevatedButton(
                                      onPressed: _isPeriodSelected == -1
                                          ? null
                                          : () {
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

                                              // if (_selectedProduct == null && _isPeriodSelected == 0) {
                                              //   if(_isPlanSelected.first == true){
                                              //     _selectedProduct = context.read<PurchaseProvider>()
                                              //         .products.firstWhere((item) => item.id == 'std-1m');
                                              //   }else if(_isPlanSelected.last == true){
                                              //     _selectedProduct = context.read<PurchaseProvider>()
                                              //         .products.firstWhere((item) => item.id == 'pre-1m');
                                              //   }
                                              // }
                                              // todo: aos 경우 restore 이후 purchaseDetail 정보를 얻어야 한다.
                                              // todo: restore 이후 데이터가 업데이트 될때까지 bloc를 실행 하면 안된다.
                                              final currentPlan = context
                                                  .read<PurchaseProvider>()
                                                  .subscribedList
                                                  .firstWhereOrNull((e) => e.isActive == true);
                                              if (Platform.isAndroid) {
                                                if (currentPlan == null) {
                                                  context.read<PurchaseBloc>().add(
                                                      RequestAosNewPurchase(product: _selectedProduct!.originProduct, userId: context.read<UserProvider>().user!.id!));
                                                } else {
                                                  context.read<PurchaseBloc>().add(PrepareUpdateRestorePurchase());
                                                }
                                              } else if (Platform.isIOS) {
                                                if (kDebugMode) {
                                                  context.read<PurchaseBloc>().add(IosPurchaseTestEvent('test'));
                                                } else {
                                                  context.read<PurchaseBloc>().add(
                                                      RequestIosPurchase(product: _selectedProduct!.originProduct));
                                                }
                                              }
                                              Get.back();
                                            },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context).colorScheme.primary),
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
                              setState(() {
                                _selectedProduct = null;
                                _isPeriodSelected = -1;
                              });
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
              ),
            );
          });
        });
  }

  Widget _planBuilder(String plan, void Function(void Function()) setState) {
    return Expanded(
      child: Selector<PurchaseProvider, List<ProductEntity>>(
        selector: (context, provider) {
          List<ProductEntity> products = List.generate(4, (idx) => ProductEntity());
          if (plan == 'Standard') {
            final list = provider.products.where((product) => product.id!.contains('std')).toList();
            for (final product in list) {
              switch (product.period) {
                case 'P1M':
                  products[0] = product;
                  break;
                case 'P3M':
                  products[1] = product;
                  break;
                case 'P6M':
                  products[2] = product;
                  break;
                case 'P1Y':
                  products[3] = product;
                  break;
              }
            }
            return products;
          } else {
            final list = provider.products.where((product) => product.id!.contains('pre')).toList();
            for (final product in list) {
              switch (product.period) {
                case 'P1M':
                  products[0] = product;
                  break;
                case 'P3M':
                  products[1] = product;
                  break;
                case 'P6M':
                  products[2] = product;
                  break;
                case 'P1Y':
                  products[3] = product;
                  break;
              }
            }
            return products;
          }
        },
        builder: (context, products, child) {
          if (products[0].id == null) {
            return const Center(child: Text('구독 상품을 불러오지 못했습니다.'));
          }
          return ListView.separated(
              shrinkWrap: false,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, idx) {
                final info =
                    context.read<PurchaseProvider>().subscribedList.firstWhereOrNull((e) => e.isActive == true);
                final discount = products[idx].period == 'P3M'
                    ? 20
                    : (products[idx].period == 'P6M' ? 25 : (products[idx].period == 'P1Y' ? 30 : 0));
                final period = products[idx].period == 'P3M'
                    ? 3
                    : (products[idx].period == 'P6M' ? 6 : (products[idx].period == 'P1Y' ? 12 : 1));

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPeriodSelected = idx;
                      _selectedProduct = products[idx];
                    });
                  },
                  child: Stack(
                    children: [
                      Container(
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
                                            products[idx].title!,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: _isPeriodSelected == idx
                                                    ? Theme.of(context).colorScheme.onSurface
                                                    : Colors.grey.shade700),
                                          ),
                                          const Gap(10),
                                          if (_isPeriodSelected == idx && discount != 0)
                                            Container(
                                                height: 25,
                                                padding: EdgeInsets.symmetric(horizontal: 8),
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.grey.shade400),
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: Colors.red.shade300),
                                                child: Center(
                                                    child: Text(
                                                  'SAVE $discount%',
                                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                                ))),
                                          //TODO: 구독 중 표시 로직 + aos 구매 테스트 / ios 구매 테스트 / 서버 데이터 저장 확인
                                          // const Gap(10),
                                          // if (isUsed)
                                          //
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('${(products[idx].rawPrice! / period).toStringAsFixed(0)}원 / 월',
                                              style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
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
                                          products[idx].price!,
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
                      if (info != null && info.productId == products[idx].id)
                        Positioned(
                            top: 4,
                            right: 8,
                            child: SizedBox(
                              child: Text('구독 중',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: plan == 'Premium' ? Colors.amber : Colors.blueAccent)),
                            ))
                    ],
                  ),
                );
              },
              separatorBuilder: (context, idx) => const Gap(10),
              itemCount: products.length);
        },
      ),
    );
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

// Map<String, dynamic> _getPackageData(StoreProduct data) {
//   Map<String, dynamic> res = {};
//   switch (data.subscriptionPeriod) {
//     case 'P1M':
//       res['title'] = '1개월 구독';
//       res['price'] = data.priceString;
//       res['discount'] = '';
//       res['perMonth'] = '${data.pricePerMonthString}/ Month';
//       break;
//     case 'P3M':
//       res['title'] = '3개월 구독';
//       res['price'] = data.priceString;
//       res['discount'] = '20%';
//       res['perMonth'] = '${data.pricePerMonthString} / Month';
//       break;
//     case 'P6M':
//       res['title'] = '6개월 구독';
//       res['price'] = data.priceString;
//       res['discount'] = '25%';
//       res['perMonth'] = '${data.pricePerMonthString} / Month';
//       break;
//     case 'P1Y':
//       res['title'] = '1년 구독';
//       res['price'] = data.priceString;
//       res['discount'] = '30%';
//       res['perMonth'] = '${data.pricePerMonthString} / Month';
//   }
//
//   return res;
// }
}
