import 'package:json_annotation/json_annotation.dart';
import 'package:test_us_app/data/models/message/message_model.dart';
import 'package:test_us_app/data/models/post/recruit_post_model.dart';

import 'member_model.dart';

part 'room_model.g.dart';

enum RoomType {
  @JsonValue('DM')
  dm,
  @JsonValue('GROUP')
  group
}

@JsonSerializable()
class RoomModel {
  int? id;
  RoomType? type;
  RecruitPostModel? post;
  String? targetUserId;
  MessageModel? lastMessage;
  String? lastMessageContent;
  DateTime? lastMessageAt;
  List<RoomMemberModel>? members;
  List<MessageModel>? messages;
  DateTime? createdAt;

  RoomModel({
    this.id,
    this.type,
    this.post,
    this.targetUserId,
    this.lastMessage,
    this.lastMessageContent,
    this.lastMessageAt,
    this.members,
    this.messages,
    this.createdAt,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) => _$RoomModelFromJson(json);
  Map<String, dynamic> toJson() => _$RoomModelToJson(this);
}
