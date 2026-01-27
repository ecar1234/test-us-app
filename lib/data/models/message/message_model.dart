import 'package:json_annotation/json_annotation.dart';
import 'package:test_us_app/data/models/package/recruit_post_applications_model.dart';
import 'package:test_us_app/data/models/user/user_model.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  int? id;
  String? content;
  User? sender;
  int? roomId;
  DateTime? createdAt;

  MessageModel({
    this.id,
    this.content,
    this.sender,
    this.roomId,
    this.createdAt
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);
  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}