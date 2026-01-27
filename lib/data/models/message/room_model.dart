import 'package:json_annotation/json_annotation.dart';
import 'package:test_us_app/data/models/message/message_model.dart';
import 'package:test_us_app/data/models/post/recruit_post_model.dart';

import '../image/image_model.dart';
import 'member_model.dart';

part 'room_model.g.dart';


enum RoomType {
  @JsonValue('DM')
  dm,
  @JsonValue('GROUP')
  group
}
@JsonSerializable()
class RoomPostModel {
  String? id;
  String? title;
  List<ImageModel>? images;

  RoomPostModel(this.id, this.title, this.images);
  factory RoomPostModel.fromJson(Map<String, dynamic> json) => _$RoomPostModelFromJson(json);
}

@JsonSerializable()
class RoomModel {
  int? id;
  RoomType? type;
  RoomPostModel? post;
  String? targetUserId;
  MessageModel? lastMessage;
  String? lastMessageContent;
  DateTime? lastMessageAt;
  List<RoomMemberModel>? members;

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
    this.createdAt,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) => _$RoomModelFromJson(json);
  Map<String, dynamic> toJson() => _$RoomModelToJson(this);
}
