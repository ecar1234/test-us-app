

import 'package:test_us_app/data/models/post/post_model.dart';
import 'package:test_us_app/domain/entities/post_entity.dart';

import '../../domain/repositories/post_repository.dart';
import '../data_sources/post_data/post_datasource.dart';

class PostRepositoryImpl implements PostRepository {
  final PostDataSource remote;
  PostRepositoryImpl(this.remote);

  @override
  Future<Map<String, dynamic>> createPost(String token, PostEntity post) async {
    final res = await remote.createPost(token, PostEntity.toPostModel(post));
    PostModel postModel = PostModel.fromJson(res['post']);
    res['post'] = PostEntity.toPostEntity(postModel);
    return res;
  }

  @override
  Future<bool> deletePost(String token, String id) async {
    final res = await remote.deletePost(token, id);
    return res;
  }

  @override
  Future<List<PostEntity>> getPostInitData() async {
    final res = await remote.getPostsInitData();
    final favoritePosts = res.map((e) => PostEntity.toPostEntity(e)).toList();
    return favoritePosts;
  }

  @override
  Future<PostEntity> getPostById(String id) {
    // TODO: implement getPostById
    throw UnimplementedError();
  }

  @override
  Future<List<PostEntity>> getPostByTitle(String title) {
    // TODO: implement getPostByTitle
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> updatePost(String token, PostEntity post) async {
    final res = await remote.updatePost(token, PostEntity.toPostModel(post));
    res['post'] = PostEntity.toPostEntity(res['post']);
    return res;
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
}