import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_us_app/domain/entities/firebase_messaging_entity.dart';

class FirebaseMessagingPreference {
  final logger = Logger();
  FirebaseMessagingPreference._internal();

  static final FirebaseMessagingPreference _singleton = FirebaseMessagingPreference._internal();

  static FirebaseMessagingPreference get instance => _singleton;

  Future<void> setFirebaseToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('firebaseToken', token);
    logger.d('firebase token saved');
  }

  Future<String?> getFirebaseToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('firebaseToken');
    logger.d('get pref token : $token');

    if (token == null) {
      return null;
    } else {
      return token;
    }
  }

  Future<void> removeFirebaseToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('firebaseToken');
    logger.i('firebase token removed');
  }

  Future<void> saveNotifications(List<String> notifications) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('notifications', notifications);
    logger.d('notifications saved');
  }
  Future<List<String>> getNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final notifications = prefs.getStringList('notifications');
    if (notifications == null) {
      return [];
    } else {
      return notifications;
    }
  }
  Future<void> removeAllNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('notifications');
    logger.d('notifications all removed');
  }

}
