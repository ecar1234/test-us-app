

import 'dart:developer' as developer;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:test_us_app/presentation/pages/my_pages/application/my_applications_page.dart';
import 'package:test_us_app/presentation/pages/my_pages/recruit/my_recruitment_page.dart';
import 'package:test_us_app/presentation/pages/my_pages/reviews/review_page.dart';

import '../../presentation/pages/message/message_main_page.dart';

class NotificationService {
  // 싱글톤 인스턴스
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // 테스터 신청용
  late NotificationDetails recruitDetails;
  // 테스터 승인,거부용
  late NotificationDetails applyDetails;
  // 리뷰용 설정
  late NotificationDetails reviewDetails;
  // 채팅용 설정
  late NotificationDetails chatDetails;


  final FlutterLocalNotificationsPlugin _localNoti = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidNoticeChannel = AndroidNotificationDetails(
      'recruit_id', '테스터 신청',
      importance: Importance.max, priority: Priority.max,
    );
    const androidApplyChannel = AndroidNotificationDetails(
      'apply_id', '테스터 신청 결과',
      importance: Importance.max, priority: Priority.max
    );
    const androidReviewChannel = AndroidNotificationDetails(
      'review_id', '리뷰 도착',
      importance: Importance.max, priority: Priority.max,
    );
    const androidChatChannel = AndroidNotificationDetails(
      'chat_id', '채팅 메시지',
      importance: Importance.high, priority: Priority.max,
    );
    try {
      await _localNoti.initialize(
        InitializationSettings(
          android: AndroidInitializationSettings('launcher_icon'),
          iOS: DarwinInitializationSettings(),
        ),
        onDidReceiveNotificationResponse: _onTapNotification,
      );
    } catch (e, s) {
      // logSystem('LocalNotification init failed: $e');
      developer.log('LocalNotification init failed: $e', name: 'LocalNotification', error: e, stackTrace: s);
    }
    recruitDetails = const NotificationDetails(android: androidNoticeChannel);
    applyDetails = const NotificationDetails(android: androidApplyChannel);
    reviewDetails = const NotificationDetails(android: androidReviewChannel);
    chatDetails = const NotificationDetails(android: androidChatChannel);
  }

  // 알림 클릭 시 처리
  void _onTapNotification(NotificationResponse res) {
    if(res.data['type'] == 'recruit'){
      Get.to(() => MyRecruitmentPage());
    }else if(res.data['type'] == 'application'){
      Get.to(() => MyApplicationsPage());
    }else if(res.data['type'] == 'review'){
      Get.to(() => ReviewPage());
    }else if(res.data['type'] == 'chat') {
      Get.to(() => MessageMainPage());
    }
    // payload를 확인하여 특정 화면으로 이동
  }

  Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    // FCM 데이터 필드(data)에 담긴 타입에 따라 미리 준비한 설정을 선택
    // 예: 서버에서 data: {"type": "chat"} 이라고 보냈을 경우
    NotificationDetails details = recruitDetails; // 기본값 공지사항
    if (message.data['type'] == 'chat') {
      details = chatDetails;
    }else if (message.data['type'] == 'application') {
      details = applyDetails;
    }else if (message.data['type'] == 'review') {
      details = reviewDetails;
    }

    await _localNoti.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
      payload: message.data['type'], // 이동할 경로 데이터 등
    );
  }
}