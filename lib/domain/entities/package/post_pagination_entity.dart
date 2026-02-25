

import 'package:test_us_app/data/models/package/post_pagination_model.dart';
import 'package:test_us_app/data/models/post/recruit_post_model.dart';
import 'package:test_us_app/domain/entities/promotion_post_entity.dart';

import '../../../data/models/post/promotion_post_model.dart';
import '../recruit_post_entity.dart';

class PostPaginationEntity<T> {
  List<T>? posts;
  int? page;
  bool? isLast;

  PostPaginationEntity({this.posts, this.page, this.isLast});

  static PostPaginationEntity<E> toEntity<M, E>({required PostPagiNationModel<M> model, required E Function(M model) mapper,}) {
    return PostPaginationEntity<E>(
      posts: model.posts?.map((m) => mapper(m)).toList() ?? [],
      page: model.page ?? 0,
      isLast: model.isLast ?? true,
    );
  }
}