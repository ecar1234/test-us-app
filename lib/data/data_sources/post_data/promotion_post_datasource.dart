

import 'package:image_picker/image_picker.dart';
import 'package:test_us_app/data/models/post/promotion_post_model.dart';

import '../../models/image/image_model.dart';
import '../../models/package/post_pagination_model.dart';

abstract class PromotionPostDataSource {
  Future<PromotionPostModel> createPost(String token, PromotionPostModel post, List<XFile> images);
  Future<PromotionPostModel> updatePost(String token, PromotionPostModel post, List<XFile> images, List<ImageModel> deleteImages);
  Future<bool> deletePost(String token, String id);
  Future<PromotionPostModel> getPromotionPostById(String token, String postId);
  Future<List<PromotionPostModel>> getUserPromotionPosts(String token, String userId);
  Future<PostPagiNationModel<PromotionPostModel>> getPostPagination(int page, int size);
}