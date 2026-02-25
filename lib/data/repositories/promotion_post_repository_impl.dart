
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/data/models/post/promotion_post_model.dart';
import 'package:test_us_app/domain/entities/image_entity.dart';
import 'package:test_us_app/domain/entities/promotion_post_entity.dart';

import '../../domain/entities/package/post_pagination_entity.dart';
import '../../domain/repositories/promotion_post_repository.dart';
import '../data_sources/post_data/promotion_post_datasource.dart';
import '../models/package/post_pagination_model.dart';

class PromotionPostRepositoryImpl implements PromotionPostRepository {
  final logger = Logger();
  final PromotionPostDataSource remote;

  PromotionPostRepositoryImpl(this.remote);

  @override
  Future<PromotionPostEntity> createPost(String token, PromotionPostEntity post, List<XFile> images) async {
    final res = await remote.createPost(token, PromotionPostEntity.toModel(post), images);
    return PromotionPostEntity.toEntity(res);
  }

  @override
  Future<PromotionPostEntity> updatePost(
      String token, PromotionPostEntity post, List<XFile> images, List<ImageEntity> deleteImages) async {
    final imagesModel = deleteImages.map((e) => ImageEntity.toImageModel(e)).toList();
    final res = await remote.updatePost(token, PromotionPostEntity.toModel(post), images, imagesModel);
    return PromotionPostEntity.toEntity(res);
  }

  @override
  Future<bool> deletePost(String token, String id) async {
    final res = await remote.deletePost(token, id);
    return res;
  }

  @override
  Future<PromotionPostEntity> getPromotionPostById(String token, String postId) async {
    final res = await remote.getPromotionPostById(token, postId);
    return PromotionPostEntity.toEntity(res);
  }

  @override
  Future<List<PromotionPostEntity>> getUserPromotionPosts(String token, String userId) async {
    final res = await remote.getUserPromotionPosts(token, userId);
    return res.map((e) => PromotionPostEntity.toEntity(e)).toList();
  }

  @override
  Future<PostPaginationEntity<PromotionPostEntity>> getPostPagination(int page, int size) async {
    final PostPagiNationModel<PromotionPostModel>  res = await remote.getPostPagination(page, size);
    final entity =  PostPaginationEntity.toEntity<PromotionPostModel, PromotionPostEntity>(
      model: res,
      mapper: (model) => PromotionPostEntity.toEntity(model),
    );
    return entity;
  }
}
