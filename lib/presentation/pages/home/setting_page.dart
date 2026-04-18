import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/presentation/bloc/purchase_bloc/purchase_state.dart';
import 'package:test_us_app/services/common_height_provider.dart';
import 'package:test_us_app/services/theme_provider.dart';

import '../../provider/purchase_provider.dart';
import '../../bloc/purchase_bloc/purchase_bloc.dart';
import '../../bloc/purchase_bloc/purchase_event.dart';
import '../../provider/user_provider.dart';

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
    return SafeArea(
        child: Scaffold(
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
                          Text(
                            "Dark Mode",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Switch(
                            value: isDark,
                            onChanged: (bool value) {
                              context.read<ThemeProvider>().changedThemeMode(value);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  BlocListener<PurchaseBloc, PurchaseState>(
                    listener: (context, state) {
                      if (state is PurchaseRestoreCompletedState) {
                        Get.snackbar("알림", '구독 내역이 복구 되었습니다.');
                        return;
                      }else if(state.state == PurchaseProgressState.error){
                        Get.snackbar("알림", state.message ?? '구매 내역 복구 중 오류가 발생했습니다.');
                        return;
                      }else if(state.state == PurchaseProgressState.failed){
                        Get.snackbar("알림", state.message ?? '구매 내역 복구에 실패 했습니다..');
                        return;
                      }
                    },
                    child: Selector<UserProvider, bool>(
                        selector: (context, provider) => provider.isLogged ?? false,
                        builder: (context, isLogged, child) {
                          if (!isLogged) {
                            return SizedBox.shrink();
                          }
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: SizedBox(
                              height: 50,
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text(
                                  '구매복원',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                SizedBox(
                                    height: 40,
                                    width: 100,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          context.read<PurchaseBloc>().add(RequestRestorePurchase());
                                        },
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            backgroundColor: Theme.of(context).colorScheme.primary),
                                        child: Text('복원 요청', style: TextStyle(color: Colors.white))))
                              ]),
                            ),
                          );
                        }),
                  )
                ],
              ),
            )));
  }
}
