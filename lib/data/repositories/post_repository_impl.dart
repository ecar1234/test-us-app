

import 'package:image_picker/image_picker.dart';
import 'package:test_us_app/data/models/post/post_model.dart';
import 'package:test_us_app/domain/entities/post_entity.dart';

import '../../domain/repositories/post_repository.dart';
import '../data_sources/post_data/post_datasource.dart';

class PostRepositoryImpl implements PostRepository {
  final PostDataSource remote;
  PostRepositoryImpl(this.remote);

  @override
  Future<PostEntity> createPost(String token, PostEntity post) async {
    final res = await remote.createPost(token, PostEntity.toPostModel(post));
    return PostEntity.toPostEntity(res);
  }

  @override
  Future<bool> deletePost(String token, String id) async {
    final res = await remote.deletePost(token, id);
    return res;
  }

  @override
  Future<Map<String, List<PostEntity>>> getPostInitData() async {
    final res = await remote.getPostsInitData();
    final List<PostEntity> favoritePosts = res['favoritePosts'] != null ?
    res['favoritePosts']!.map((e) => PostEntity.toPostEntity(e)).toList() : [];
    final List<PostEntity> posts = res['posts'] != null ?
    res['posts']!.map((e) => PostEntity.toPostEntity(e)).toList() : [];

    return {'favoritePosts': favoritePosts, 'posts': posts};
  }

  @override
  Future<PostEntity> getPostById(String token, String id) async {
    final res = await remote.getPostById(token, id);
    return PostEntity.toPostEntity(res);
  }

  @override
  Future<List<PostEntity>> getPostByTitle(String title) {
    // TODO: implement getPostByTitle
    throw UnimplementedError();
  }

  @override
  Future<PostEntity> updatePost(String token, PostEntity post) async {
    final res = await remote.updatePost(token, PostEntity.toPostModel(post));
    return PostEntity.toPostEntity(res);
  }

  @override
  Future<List<PostEntity>> getWebPosts(int page) async {
    final res = await remote.getWebPosts(page);
    return res.map((e) => PostEntity.toPostEntity(e)).toList();
  }

  @override
  Future<List<PostEntity>> getMobilePosts(int page) async {
    final res = await remote.getMobilePosts(page);
    return res.map((e) => PostEntity.toPostEntity(e)).toList();
  }
  @override
  Future<List<PostEntity>> getPostPagination(int page) async {
    final res = await remote.getPostsPagination(page);
    return res.map((e) => PostEntity.toPostEntity(e)).toList();
  }

  @override
  Future<bool> deletePostImg(String token, Map<String, dynamic> imgInfo) {
    // TODO: implement deletePostImg
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> registerPostImg(String token, List<XFile> images, String postId) async {
    final res = await remote.registerPostImg(token, images, postId);
    return res;
  }

  @override
  Future<List<Map<String, dynamic>>> updatePostImg(String token, List<XFile> images, List<Map<String, dynamic>> oldImgInfo) {
    // TODO: implement updatePostImg
    throw UnimplementedError();
  }
}