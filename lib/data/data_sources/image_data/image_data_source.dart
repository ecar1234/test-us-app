

import 'package:image_picker/image_picker.dart';

import '../../models/post/image_model.dart';
import '../../models/post/post_model.dart';

abstract class ImageDataSource {
  Future<PostModel> registerPostImg(String token, List<XFile> images, String postId);
  Future<PostModel> updatePostImg(String token, List<ImageModel> deleteImages, List<XFile> images, String postId);
  Future<bool> deletePostImg(String token, List<Map<String, dynamic>> deleteImages);
}