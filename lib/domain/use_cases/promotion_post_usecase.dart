

import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/domain/entities/image_entity.dart';
import 'package:test_us_app/domain/entities/promotion_post_entity.dart';

import '../entities/package/post_pagination_entity.dart';
import '../repositories/promotion_post_repository.dart';

class PromotionPostUseCase {
  final logger = Logger();
  final PromotionPostRepository repository;
  PromotionPostUseCase(this.repository);

  Future<PromotionPostEntity> createPost(String token, PromotionPostEntity post, List<XFile> images) async {
    final res = await repository.createPost(token, post, images);
    return res;
  }
  Future<PromotionPostEntity> updatePost(String token, PromotionPostEntity post, List<XFile> images, List<ImageEntity> deleteImages) async {
    final res = await repository.updatePost(token, post, images, deleteImages);
    return res;
  }
  Future<bool> deletePost(String token, String id) async {
    final res = await repository.deletePost(token, id);
    return res;
  }
  Future<PromotionPostEntity> getPromotionPostById(String token, String id) async {
    final res = await repository.getPromotionPostById(token, id);
    return res;
  }
  Future<List<PromotionPostEntity>> getUserPromotionPosts(String token, String userId) async {
    final res = await repository.getUserPromotionPosts(token, userId);
    return res;
  }

  Future<PostPaginationEntity<PromotionPostEntity>> getPostPagination(int page, int size) async {
    final res = await repository.getPostPagination(page, size);
    return res;
  }
}