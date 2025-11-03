import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/domain/entities/application_entity.dart';
import 'package:test_us_app/services/common_height_provider.dart';

import '../../../provider/application_provider.dart';

class MyApplicationsPage extends StatefulWidget {
  const MyApplicationsPage({super.key});

  @override
  State<MyApplicationsPage> createState() => _MyApplicationsPageState();
}

class _MyApplicationsPageState extends State<MyApplicationsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Applications'),
        ),
        body: Padding(
            padding: EdgeInsets.all(20),
          child: Selector<ApplicationProvider, List<ApplicationEntity>>(
              selector: (context, provider) => provider.userApplications ?? [],
              builder: (context, applications, child) {
                final hei = GetIt.I.get<ResponsiveHeightProvider>().hei ?? 0;
                return applications.isEmpty ?
                 SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: hei,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('작성 된 모집글이 없습니다.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                      const Gap(10),
                      Text('나만의 서비스가 있다면 테스터를'),
                      Text('모집해 보세요.'),
                    ],
                  ),
                )
                : ListView.separated(
                  itemBuilder: (context, idx) {
                    return Card(
                      child: Center(
                        child: Text(applications[idx].status.toString()),
                      ),
                    );
                  },
                  separatorBuilder: (context, idx) => Gap(10),
                  itemCount: applications.length
                );
              },
          )
        )
        ),
      );
  }
}
