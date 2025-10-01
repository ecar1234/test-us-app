import 'package:image_picker/image_picker.dart';

import '../entities/image_entity.dart';
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class PostUseCase {
  final PostRepository repository;

  PostUseCase(this.repository);

  Future<Map<String, List<PostEntity>>> getPostInitData() async {
    final initData = await repository.getPostInitData();
    return {'favoritePosts': initData['favoritePosts']!, 'posts': initData['posts']!};
  }

  Future<PostEntity> getPostById(String token, String id) async {
    final res = await repository.getPostById(token, id);
    return res;
  }

  Future<List<PostEntity>> getWebPosts(int page) async {
    final res = await repository.getWebPosts(page);
    return res;
  }

  Future<List<PostEntity>> getMobilePosts(int page) async {
    final res = await repository.getMobilePosts(page);
    return res;
  }

  Future<PostEntity> updatePost(String token, PostEntity post) async {
    final res = await repository.updatePost(token, post);
    return res;
  }

  Future<bool> deletePost(String token, String id) async {
    final res = await repository.deletePost(token, id);
    return res;
  }

  Future<PostEntity> createPost(String token, PostEntity post) async {
    final res = await repository.createPost(token, post);
    return res;
  }

  // Future<PostEntity> getPostById(String id) async {
  //   final res = await repository.getPostById(id);
  //   return res;
  // }
  Future<List<PostEntity>> getPostByTitle(String title) async {
    final res = await repository.getPostByTitle(title);
    return res;
  }

  Future<List<PostEntity>> getPostPagination(int page) async {
    final res = await repository.getPostPagination(page);
    return res;
  }

  Future<PostEntity> registerPostImg(String token, List<XFile> images, String postId) async {
    final res = await repository.registerPostImg(token, images, postId);
    return res;
  }

  Future<PostEntity> updatePostImg(String token, List<ImageEntity> deleteImages, List<XFile> images, String postId) async {
    final res = await repository.updatePostImg(token, deleteImages, images, postId);
    return res;
  }

  Future<bool> deletePostImg(String token, List<ImageEntity> deleteImages) async {
    final res = await repository.deletePostImg(token, deleteImages);
    return res;
  }
}
