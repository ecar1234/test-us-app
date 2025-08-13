

import 'package:test_us_app/domain/entities/post_entity.dart';

import '../../domain/repositories/post_repository.dart';
import '../data_sources/post_data/post_datasource.dart';

class PostRepositoryImpl implements PostRepository {
  final PostDataSource remote;
  PostRepositoryImpl(this.remote);

  @override
  Future<Map<String, dynamic>> createPost(String token, PostEntity post) async {
    final res = await remote.createPost(token, PostEntity.toPostModel(post));
    res['post'] = PostEntity.toPostEntity(res['post']);
    return res;
  }

  @override
  Future<bool> deletePost(String token, String id) {
    // TODO: implement deletePost
    throw UnimplementedError();
  }

  @override
  Future<List<PostEntity>> getPostAllData() async {
    final res = await remote.getPostAllData();
    if(res.isEmpty) {
      return [];
    } else {
      final postList = res.map((e) => PostEntity.toPostEntity(e)).toList();
      return postList;
    }
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
  
  

}