// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
  id: (json['id'] as num?)?.toInt(),
  content: json['content'] as String?,
  sender: json['sender'] == null
      ? null
      : User.fromJson(json['sender'] as Map<String, dynamic>),
  roomId: (json['roomId'] as num?)?.toInt(),
  createdAt: MessageModel._dateTimeFromUtc(json['createdAt'] as String),
);

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'sender': instance.sender,
      'roomId': instance.roomId,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
