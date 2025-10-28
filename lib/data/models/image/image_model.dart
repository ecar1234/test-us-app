

import 'package:json_annotation/json_annotation.dart';
part 'image_model.g.dart';

enum PostType {
  @JsonValue('promotion')
  promotion,
  @JsonValue('recruit')
  recruit,
}

@JsonSerializable()
class ImageModel {
  int? id;
  String? filename;
  String? originalname;
  String? mimetype;
  int? size;
  PostType? postType;
  String? url;
  DateTime? createdAt;

  ImageModel({this.id, this.filename, this.originalname, this.mimetype, this.size, this.postType, this.url, this.createdAt});

  factory ImageModel.fromJson(Map<String, dynamic> json) => _$ImageModelFromJson(json);
  Map<String, dynamic> toJson() => _$ImageModelToJson(this);
}