

import 'package:image_picker/image_picker.dart';

import '../entities/image_entity.dart';
import '../entities/post_entity.dart';

abstract class ImageRepository {
  Future<PostEntity> registerPostImg(String token, List<XFile> images, String postId);
  Future<PostEntity> updatePostImg(String token, List<ImageEntity> deleteImages, List<XFile> images, String postId);
  Future<bool> deletePostImg(String token, List<ImageEntity> deleteImages);
}