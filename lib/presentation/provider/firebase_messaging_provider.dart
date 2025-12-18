

import 'package:flutter/material.dart';

import '../../domain/entities/firebase_messaging_entity.dart';
import '../../domain/use_cases/firebase_messaging_usecase.dart';

class FirebaseMessagingProvider with ChangeNotifier{
  final FirebaseMessagingUseCase useCase;
  FirebaseMessagingProvider(this.useCase);

  List<FirebaseMessagingEntity>? _notifications;
  List<FirebaseMessagingEntity>? get notifications => _notifications;

  String? _token;
  String? get token => _token;

  Future<void> setFirebaseToken(String token) async {
    await useCase.setFirebaseToken(token);
    _token = token;
    notifyListeners();
  }
  Future<void> getFirebaseToken() async {
    final token = await useCase.getFirebaseToken();
    _token = token;
    notifyListeners();
  }
  Future<void> removeFirebaseToken() async {
    await useCase.removeFirebaseToken();
    _token = null;
    notifyListeners();
  }

  Future<void> saveNotification(FirebaseMessagingEntity notification) async {
    await useCase.saveNotification(notification);
    _notifications ??= [];
    _notifications = [notification, ..._notifications!];
    notifyListeners();
  }
  Future<void> getNotification() async {
    final notifications = await useCase.getNotification();
    _notifications = notifications;
    notifyListeners();
  }
  Future<void> removeNotification(String id) async {
    await useCase.removeNotification(id);
    _notifications = _notifications!.where((element) => element.id! != id).toList();
    notifyListeners();
  }
  Future<void> removeAllNotification() async {
    await useCase.removeAllNotification();
    _notifications = [];
    notifyListeners();
  }

  Future<void> readNotification(int id) async {
    final index = _notifications!.indexWhere((e) => e.id == id);
    if (index == -1) return;
    _notifications![index].isRead = true;
    final updated = _notifications![index];
    // 같은 위치에 교체 — 리스트 참조는 새로 생성

    // 같은 위치에 교체 — 리스트 참조는 새로 생성
    _notifications = [
      ..._notifications!.sublist(0, index),
      updated,
      ..._notifications!.sublist(index + 1),
    ];

    await useCase.saveNotification(updated);

    notifyListeners();
  }
  Future<void> readAllNotification() async {
    if (_notifications == null || _notifications!.isEmpty) {
      return;
    }
    final allReadNotifications = _notifications!.map((notification) {
      return FirebaseMessagingEntity(
        id: notification.id,
        title: notification.title,
        body: notification.body,
        createdAt: notification.createdAt,
        data: notification.data,
        isRead: true
      );
    }).toList();
    _notifications = allReadNotifications;
    await useCase.allReadChangeSaveNotification(_notifications!);
    notifyListeners();
  }
}

