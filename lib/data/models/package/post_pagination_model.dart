
import 'package:json_annotation/json_annotation.dart';
part 'post_pagination_model.g.dart';

@JsonSerializable(explicitToJson: true, genericArgumentFactories: true)
class PostPagiNationModel<T> {
  List<T>? posts;
  int? page;
  bool? isLast;

  PostPagiNationModel({this.posts, this.page, this.isLast});

  factory PostPagiNationModel.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) => _$PostPagiNationModelFromJson(json, fromJsonT);
}