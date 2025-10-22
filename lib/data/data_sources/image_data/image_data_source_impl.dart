

import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:test_us_app/core/net_driver.dart';

import '../../../core/api_names.dart';
import '../../models/image/image_model.dart';
import '../../models/post/recruit_post_model.dart';
import 'image_data_source.dart';

class ImageDataSourceImpl implements ImageDataSource {
  final NetDriver netDriver;
  final logger = Logger();
  ImageDataSourceImpl(this.netDriver);


  @override
  Future<RecruitPostModel> registerPostImg(String token, List<XFile> images, String postId) async {
    final res = await netDriver.requestImagesRegisterFormData(token, ImageApi.registerPostImg, images, postId);
    if (res['status'] == 200) {
      return RecruitPostModel.fromJson(res['post']);
    } else {
      throw Exception('Error');
    }
  }

  @override
  Future<RecruitPostModel> updatePostImg(
      String token, List<ImageModel> deleteImages, List<XFile> images, String postId) async {
    try {
      final deleteData = deleteImages.map((e) => e.toJson()).toList();
      final res = await netDriver.requestImagesUpdateFormData(token, ImageApi.updatePostImg, deleteData, images, postId);
      if (res['status'] == 200) {
        return RecruitPostModel.fromJson(res['post']);
      } else {
        throw Exception('Error');
      }
    } on Exception catch (e) {
      // TODO
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<bool> deletePostImg(String token, List<Map<String, dynamic>> deleteImages) async {
    final res = await netDriver.requestImagesDeleteFormData(token, ImageApi.deletePostImg, deleteImages);
    if (res['status'] == 200) {
      return res['result'];
    } else {
      throw Exception('Error');
    }
  }
}