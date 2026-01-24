import 'package:json_annotation/json_annotation.dart';
import 'package:test_us_app/data/models/user/user_model.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  String? id;
  String? content;
  UserModel? sender;
  String? receiver;
  bool? deleteSender;
  bool? deleteReceiver;
  DateTime? createdAt;

  MessageModel({
    this.id,
    this.content,
    this.sender,
    this.receiver,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);
  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}