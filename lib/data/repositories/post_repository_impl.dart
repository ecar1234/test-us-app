

import 'package:test_us_app/domain/entities/post_entity.dart';

import '../../domain/repositories/post_repository.dart';
import '../data_sources/post_data/post_datasource.dart';

class PostRepositoryImpl implements PostRepository {
  final PostDataSource remote;
  PostRepositoryImpl(this.remote);

  @override
  Future<bool> createPost(String token, PostEntity post) async {
    final res = await remote.createPost(token, PostEntity.toPostModel(post));
    return res;
  }

  @override
  Future<bool> deletePost(String token, String id) {
    // TODO: implement deletePost
    throw UnimplementedError();
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
  Future<bool> updatePost(String token, PostEntity post) {
    // TODO: implement updatePost
    throw UnimplementedError();
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