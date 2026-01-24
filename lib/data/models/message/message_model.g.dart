// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      id: json['id'] as String?,
      content: json['content'] as String?,
      sender: json['sender'] == null
          ? null
          : UserModel.fromJson(json['sender'] as Map<String, dynamic>),
      receiver: json['receiver'] as String?,
    )
      ..deleteSender = json['deleteSender'] as bool?
      ..deleteReceiver = json['deleteReceiver'] as bool?
      ..createdAt = json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String);

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'sender': instance.sender,
      'receiver': instance.receiver,
      'deleteSender': instance.deleteSender,
      'deleteReceiver': instance.deleteReceiver,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
