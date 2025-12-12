import 'dart:convert';

class FirebaseMessagingEntity {
  String? id;
  String? title;
  String? body;
  DateTime? createdAt;
  Map<String, dynamic>? data;
  bool? isRead;


  FirebaseMessagingEntity({
    this.id,
    this.title,
    this.body,
    this.createdAt,
    this.data,
    this.isRead,
  });

  static FirebaseMessagingEntity fromJson(String json) {
    final data = jsonDecode(json);
    return FirebaseMessagingEntity(
      id: data['id'],
      title: data['title'],
      body: data['body'],
      createdAt: DateTime.parse(data['createdAt']),
      data: data['data'],
      isRead: data['isRead'],
    );
  }
  static String toJson(FirebaseMessagingEntity entity) {
    return jsonEncode(entity);
  }
}
