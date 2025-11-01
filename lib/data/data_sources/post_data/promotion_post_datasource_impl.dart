
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/core/api_names.dart';
import 'package:test_us_app/core/net_driver.dart';
import 'package:test_us_app/data/data_sources/post_data/promotion_post_datasource.dart';
import 'package:test_us_app/data/models/post/promotion_post_model.dart';

import '../../models/image/image_model.dart';

class PromotionPostDataSourceImpl implements PromotionPostDataSource {
  final logger = Logger();
  final NetDriver netDriver;
  PromotionPostDataSourceImpl(this.netDriver);

  @override
  Future<PromotionPostModel> createPost(String token, PromotionPostModel post, List<XFile> images) async {
    try {
      final res = await netDriver.requestRegisterFormData(token, PromotionApi.createPromotionPost, images, post.toJson());
      if(res['status'] == 200) {
        return PromotionPostModel.fromJson(res['post']);
      }else{
        throw Exception(res['message']);
      }
    } on Exception catch (e) {
      // TODO
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<PromotionPostModel> updatePost(String token, PromotionPostModel post, List<XFile> images, List<ImageModel> deleteImages) async {
    try {
      final oldImages = deleteImages.map((e) => e.toJson()).toList();
      final res = await netDriver.requestUpdateFormData(token, PromotionApi.update, post.toJson(), images, oldImages);
      if(res['status'] == 200) {
        return PromotionPostModel.fromJson(res['post']);
      } else {
        throw Exception(res['message']);
      }
    } on Exception catch (e) {
      // TODO
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<bool> deletePost(String token, String id) async {
    final data = {"id": id};
    final res = await netDriver.requestPostJson(token, PromotionApi.delete, data);
    if (res['status'] == 200) {
      return true;
    } else {
      throw false;
    }
  }

  @override
  Future<PromotionPostModel> getPromotionPostById(String token, String postId) async {
    final res = await netDriver.requestGetJson(token, PromotionApi.getPostById, param: postId);
    if (res['status'] == 200) {
      return PromotionPostModel.fromJson(res['post']);
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<List<PromotionPostModel>> getUserPromotionPosts(String token, String userId) async {
    final res = await netDriver.requestGetJson(token, PromotionApi.getUserRecruitmentPosts, param: userId);
    if (res['status'] == 200) {
      if(res['posts'] == null || res['posts'] == []){
        return [];
      }
      return (res['posts'] as List).map<PromotionPostModel>((e) => PromotionPostModel.fromJson(e)).toList();
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<List<PromotionPostModel>> getPostPagination(int page, int size) async {
    final res = await netDriver.requestPostJson(page.toString(), PromotionApi.getPostsPagination,
        {'size': size, 'page': page});
    if (res['status'] == 200) {
      // logger.d(res['posts']);
      return (res['posts'] as List).map<PromotionPostModel>((e) => PromotionPostModel.fromJson(e)).toList();
    } else {
      throw Exception('Error');
    }
  }

}