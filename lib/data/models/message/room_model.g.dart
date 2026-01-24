// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomModel _$RoomModelFromJson(Map<String, dynamic> json) => RoomModel(
      id: (json['id'] as num?)?.toInt(),
      type: $enumDecodeNullable(_$RoomTypeEnumMap, json['type']),
      post: json['post'] == null
          ? null
          : RecruitPostModel.fromJson(json['post'] as Map<String, dynamic>),
      targetUserId: json['targetUserId'] as String?,
      lastMessage: json['lastMessage'] == null
          ? null
          : MessageModel.fromJson(json['lastMessage'] as Map<String, dynamic>),
      lastMessageContent: json['lastMessageContent'] as String?,
      lastMessageAt: json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String),
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => RoomMemberModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$RoomModelToJson(RoomModel instance) => <String, dynamic>{
      'id': instance.id,
      'type': _$RoomTypeEnumMap[instance.type],
      'post': instance.post,
      'targetUserId': instance.targetUserId,
      'lastMessage': instance.lastMessage,
      'lastMessageContent': instance.lastMessageContent,
      'lastMessageAt': instance.lastMessageAt?.toIso8601String(),
      'members': instance.members,
      'messages': instance.messages,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$RoomTypeEnumMap = {
  RoomType.dm: 'DM',
  RoomType.group: 'GROUP',
};
