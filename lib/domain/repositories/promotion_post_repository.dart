

import 'package:image_picker/image_picker.dart';
import 'package:test_us_app/domain/entities/image_entity.dart';
import 'package:test_us_app/domain/entities/package/post_pagination_entity.dart';
import 'package:test_us_app/domain/entities/promotion_post_entity.dart';

abstract class PromotionPostRepository {
  Future<PromotionPostEntity> createPost(String token, PromotionPostEntity post, List<XFile> images);
  Future<PromotionPostEntity> updatePost(String token, PromotionPostEntity post, List<XFile> images, List<ImageEntity> deleteImages);
  Future<bool> deletePost(String token, String id);
  Future<PromotionPostEntity> getPromotionPostById(String token, String postId);
  Future<List<PromotionPostEntity>> getUserPromotionPosts(String token, String userId);
  Future<PostPaginationEntity<PromotionPostEntity>> getPostPagination(int page, int size);
}


