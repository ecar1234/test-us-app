// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomMemberModel _$RoomMemberModelFromJson(Map<String, dynamic> json) =>
    RoomMemberModel(
      id: (json['id'] as num?)?.toInt(),
      roomId: (json['roomId'] as num?)?.toInt(),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
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
      'roomId': instance.roomId,
      'user': instance.user,
      'unreadCount': instance.unreadCount,
      'lastReadMessageId': instance.lastReadMessageId,
      'isActive': instance.isActive,
      'joinedAt': instance.joinedAt?.toIso8601String(),
    };
