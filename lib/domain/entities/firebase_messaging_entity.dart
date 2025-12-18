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
      isRead: data['isRead'] == 'true' ? true : false,
    );
  }
  static String toJson(FirebaseMessagingEntity entity) {
   Map<String, dynamic> json = {
     'id': entity.id,
     'title': entity.title,
     'body': entity.body,
     'createdAt': entity.createdAt?.toIso8601String(),
     'data': entity.data,
     'isRead': entity.isRead == true ? 'true' : 'false'
   };

    return jsonEncode(json);
  }
}
