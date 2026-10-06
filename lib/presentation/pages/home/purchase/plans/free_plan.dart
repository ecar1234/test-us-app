import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/entities/purchase_entity.dart';
import '../../../../../services/theme_provider.dart';
import '../../../../provider/purchase_provider.dart';

class FreePlan extends StatefulWidget {
  const FreePlan({super.key});

  @override
  State<FreePlan> createState() => _FreePlanState();
}

class _FreePlanState extends State<FreePlan> {

  final List<String> plan = [
    '테스터 모집 포스팅 1개',
    '서비스 홍보 포스팅 1개',
    '포스트 이미지 최대 4장(총 25Mb)',
    '포스팅 기간 최대 7일',
    '메시지 보관 3일',
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.read<ThemeProvider>().isDarkMode;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: isDarkMode ? Colors.white : Colors.orange),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          SizedBox(
            height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Free Plan', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                  Selector<PurchaseProvider, PurchaseEntity?>(
                      selector: (context, provider) {
                        final plan = provider.getUserPurchasePlan();
                        if(plan == null){
                          return null;
                        }else {
                          return plan;
                        }
                      },
                      builder:(context, subscribe, child) {
                        if(subscribe == null){
                          return Container(
                            height: 25,
                            // width: 80,
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: Center(child: const Text('기본 제공', style: TextStyle(color: Colors.white),)),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      }
                  )
                ],
              )
          ),
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, idx){
                  return SizedBox(
                    height: 30,
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.green,),
                        const Gap(4),
                        Text(plan[idx])
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, idx) => const Gap(8),
                itemCount: plan.length),
          ),
        ],
      )
    );
  }
}
