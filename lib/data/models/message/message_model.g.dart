// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      messageId: json['messageId'] as String?,
      message: json['message'] as String?,
      sender: json['sender'] as String?,
      receiver: json['receiver'] as String?,
      deleteSender: json['deleteSender'] as bool?,
      deleteReceiver: json['deleteReceiver'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'message': instance.message,
      'sender': instance.sender,
      'receiver': instance.receiver,
      'deleteSender': instance.deleteSender,
      'deleteReceiver': instance.deleteReceiver,
      'createdAt': instance.createdAt?.toIso8601String(),
      'readAt': instance.readAt?.toIso8601String(),
    };
