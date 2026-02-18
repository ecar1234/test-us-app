import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/presentation/pages/message/message_main_page.dart';
import 'package:test_us_app/presentation/pages/my_pages/application/my_applications_page.dart';
import 'package:test_us_app/presentation/pages/my_pages/recruit/my_recruitment_page.dart';
import 'package:test_us_app/presentation/pages/my_pages/reviews/review_page.dart';
import 'package:test_us_app/utils/time_util.dart';

import '../../domain/entities/firebase_messaging_entity.dart';
import '../../services/common_height_provider.dart';
import '../../services/theme_provider.dart';
import '../provider/firebase_messaging_provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<FirebaseMessagingProvider>().readAllNotification();
  }

  @override
  Widget build(BuildContext context) {
    final hei = GetIt.I.get<ResponsiveHeightProvider>().hei!;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('알림'),
        ),
        body: Container(
          height: hei,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Selector<FirebaseMessagingProvider, List<FirebaseMessagingEntity>>(selector: (context, provider) {
            List<FirebaseMessagingEntity> notifications = [];
            if (provider.notifications != null) {
              notifications = provider.notifications!;
            }
            return notifications;
          }, builder: (context, notifications, child) {
            final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
            if (notifications.isEmpty) {
              return Center(child: Text('알림이 없습니다 ✉️'));
            }
            return Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  SizedBox(
                      height: 28,
                      child: TextButton(
                          onPressed: () {
                            context.read<FirebaseMessagingProvider>().removeAllNotification();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Text('전체 삭제')))
                ]),
                const Gap(5),
                Expanded(
                  child: ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, idx) {
                        return GestureDetector(
                          onTap: () {
                            if (notifications[idx].data!['type'] == 'recruit') {
                              Get.to(() => MyRecruitmentPage());
                            } else if (notifications[idx].data!['type'] == 'application') {
                              Get.to(() => MyApplicationsPage());
                            } else if (notifications[idx].data!['type'] == 'chat') {
                              Get.to(() => MessageMainPage());
                            } else {
                              Get.to(() => ReviewPage());
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                                border: Border.all(color: Colors.grey),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _getTitle(notifications[idx].data!['type']!),
                                      style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 28,
                                      child: TextButton(
                                          onPressed: () {
                                            context
                                                .read<FirebaseMessagingProvider>()
                                                .removeNotification(notifications![idx].id!);
                                          },
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                          ),
                                          child: Text('삭제')),
                                    )
                                  ],
                                ),
                                Text(
                                  '${notifications[idx].data!['title']} 알림',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Gap(4),
                                Text(notifications[idx].body!),
                                const Gap(10),
                                Text(TimeUtil().getDateTimeString(notifications[idx].createdAt!, true),
                                    style: TextStyle(color: Colors.grey))
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, idx) => const Gap(20),
                      itemCount: notifications.length),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  String _getTitle(String type) {
    switch (type) {
      case 'recruit':
        return '테스터 모집';
      case 'application':
        return '테스터 신청';
      case 'chat':
        return '새로운 메시지';
      case 'review':
        return '리뷰 관리';
      default:
        return '';
    }
  }
}
