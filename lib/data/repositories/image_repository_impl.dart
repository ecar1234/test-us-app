

import 'package:image_picker/image_picker.dart';
import 'package:test_us_app/data/data_sources/image_data/image_data_source.dart';

import '../../domain/entities/image_entity.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/repositories/image_repository.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageDataSource remote;
  ImageRepositoryImpl(this.remote);

  @override
  Future<PostEntity> registerPostImg(String token, List<XFile> images, String postId) async {
    final res = await remote.registerPostImg(token, images, postId);
    return PostEntity.toPostEntity(res);
  }

  @override
  Future<PostEntity> updatePostImg(String token, List<ImageEntity> deleteImages, List<XFile> images, String postId) async {
    final deleteData = deleteImages.map((e) => ImageEntity.toImageModel(e)).toList();
    final res = await remote.updatePostImg(token, deleteData, images, postId);
    return PostEntity.toPostEntity(res);
  }

  @override
  Future<bool> deletePostImg(String token, List<ImageEntity> deleteImages) async {
    final deleteData = deleteImages.map((e) => {'id': e.id, 'url': e.url}).toList();
    final res = await remote.deletePostImg(token, deleteData);
    return res;
  }

}