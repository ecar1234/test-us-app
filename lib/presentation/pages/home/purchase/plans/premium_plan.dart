import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/services/theme_provider.dart';

import '../../../../../domain/entities/purchase_entity.dart';
import '../../../../provider/purchase_provider.dart';

class PremiumPlan extends StatefulWidget {
  const PremiumPlan({super.key});

  @override
  State<PremiumPlan> createState() => _PremiumPlanState();
}

class _PremiumPlanState extends State<PremiumPlan> {

  final List<String> plan = [
    '테스터 모집 포스팅 4개',
    '서비스 홍보 포스팅 4개',
    '포스트 이미지 최대 8장(총 80Mb)',
    '포스팅 기간 최대 30일',
    '메시지 보관 무제한',
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
                  Text('Premium', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                  Selector<PurchaseProvider, PurchaseEntity?>(
                      selector: (context, provider) {
                        final plan = provider.getUserPurchasePlan();
                        if(plan == null){
                          return null;
                        }else {
                          if(plan.plan! == 'Premium'){
                            return plan;
                          }else {
                            return null;
                          }
                        }
                      },
                      builder:(context, subscribe, child) {
                        if(subscribe != null){
                          return Container(
                            height: 25,
                            // width: 80,
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: Center(child: const Text('구독중', style: TextStyle(color: Colors.white),)),
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
