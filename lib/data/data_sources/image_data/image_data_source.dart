

import 'package:image_picker/image_picker.dart';

import '../../models/image/image_model.dart';
import '../../models/post/recruit_post_model.dart';

abstract class ImageDataSource {
  Future<RecruitPostModel> registerPostImg(String token, List<XFile> images, String postId);
  Future<RecruitPostModel> updatePostImg(String token, List<ImageModel> deleteImages, List<XFile> images, String postId);
  Future<bool> deletePostImg(String token, List<Map<String, dynamic>> deleteImages);
}