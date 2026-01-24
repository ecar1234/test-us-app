// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomMemberModel _$RoomMemberModelFromJson(Map<String, dynamic> json) =>
    RoomMemberModel(
      id: (json['id'] as num?)?.toInt(),
      room: json['room'] == null
          ? null
          : RoomModel.fromJson(json['room'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      userId: json['userId'] as String?,
      unreadCount: (json['unreadCount'] as num?)?.toInt(),
      lastReadMessageId: (json['lastReadMessageId'] as num?)?.toInt(),
      isActive: json['isActive'] as bool?,
      joinedAt: json['joinedAt'] == null
          ? null
          : DateTime.parse(json['joinedAt'] as String),
    );

Map<String, dynamic> _$RoomMemberModelToJson(RoomMemberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'room': instance.room,
      'user': instance.user,
      'userId': instance.userId,
      'unreadCount': instance.unreadCount,
      'lastReadMessageId': instance.lastReadMessageId,
      'isActive': instance.isActive,
      'joinedAt': instance.joinedAt?.toIso8601String(),
    };
