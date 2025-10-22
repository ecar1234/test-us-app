import 'package:image_picker/image_picker.dart';

import '../entities/image_entity.dart';
import '../entities/recruit_post_entity.dart';
import '../repositories/image_repository.dart';

class ImageUseCase {
  final ImageRepository repository;
  ImageUseCase(this.repository);

  Future<RecruitPostEntity> registerPostImg(String token, List<XFile> images, String postId) async {
    final res = await repository.registerPostImg(token, images, postId);
    return res;
  }

  Future<RecruitPostEntity> updatePostImg(String token, List<ImageEntity> deleteImages, List<XFile> images, String postId) async {
    final res = await repository.updatePostImg(token, deleteImages, images, postId);
    return res;
  }

  Future<bool> deletePostImg(String token, List<ImageEntity> deleteImages) async {
    final res = await repository.deletePostImg(token, deleteImages);
    return res;
  }
}