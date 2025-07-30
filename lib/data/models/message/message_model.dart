import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  String? messageId;
  String? message;
  String? sender;
  String? receiver;
  bool? deleteSender;
  bool? deleteReceiver;
  DateTime? createdAt;
  DateTime? readAt;

  MessageModel({
    this.messageId,
    this.message,
    this.sender,
    this.receiver,
    this.deleteSender,
    this.deleteReceiver,
    this.createdAt,
    this.readAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);
  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}