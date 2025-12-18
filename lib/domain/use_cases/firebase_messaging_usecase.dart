

import '../../data/sharedPreferences/firebase_messaging_preference.dart';
import '../entities/firebase_messaging_entity.dart';

class FirebaseMessagingUseCase {
  final pref = FirebaseMessagingPreference.instance;

  Future<void> setFirebaseToken(String token) async {
    await pref.setFirebaseToken(token);
  }

  Future<String?> getFirebaseToken() async {
    final token = await pref.getFirebaseToken();
    return token;
  }

  Future<void> removeFirebaseToken() async {
    await pref.removeFirebaseToken();
  }

  Future<void> saveNotification(FirebaseMessagingEntity notification) async {
    List<String> notifications = await pref.getNotifications();
    notifications.add(FirebaseMessagingEntity.toJson(notification));
    await pref.saveNotifications(notifications);
  }
  Future<void> allReadChangeSaveNotification(List<FirebaseMessagingEntity> notifications) async {
    List<String> notificationsString = notifications.map((e) => FirebaseMessagingEntity.toJson(e)).toList();
    await pref.saveNotifications(notificationsString);
  }
  Future<List<FirebaseMessagingEntity>> getNotification() async {
    final notifications = await pref.getNotifications();
    final res = notifications.map((e) => FirebaseMessagingEntity.fromJson(e)).toList();
    res.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    return res;
  }
  Future<void> removeNotification(String id) async {
    List<String> notifications = await pref.getNotifications();
    notifications.removeWhere((element) => FirebaseMessagingEntity.fromJson(element).id == id);
    await pref.saveNotifications(notifications);
  }
  Future<void> removeAllNotification() async {
    await pref.removeAllNotification();
  }

}