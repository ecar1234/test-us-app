import 'package:json_annotation/json_annotation.dart';
import 'package:test_us_app/data/models/message/room_model.dart';
import 'package:test_us_app/data/models/user/user_model.dart';

part 'member_model.g.dart';

@JsonSerializable()
class RoomMemberModel {
  int? id;
  int? roomId;
  UserModel? user;
  int? unreadCount;
  int? lastReadMessageId;
  bool? isActive;
  DateTime? joinedAt;

  RoomMemberModel({
    this.id,
    this.roomId,
    this.user,
    this.unreadCount,
    this.lastReadMessageId,
    this.isActive,
    this.joinedAt,
  });

  factory RoomMemberModel.fromJson(Map<String, dynamic> json) => _$RoomMemberModelFromJson(json);
  Map<String, dynamic> toJson() => _$RoomMemberModelToJson(this);
}
