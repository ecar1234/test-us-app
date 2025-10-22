

import 'package:image_picker/image_picker.dart';
import 'package:test_us_app/data/models/image/image_model.dart';
import 'package:test_us_app/data/models/post/recruit_post_model.dart';
import 'package:test_us_app/domain/entities/recruit_post_entity.dart';

import '../../domain/entities/image_entity.dart';
import '../../domain/repositories/recruit_post_repository.dart';
import '../data_sources/post_data/recruit_post_datasource.dart';

class RecruitPostRepositoryImpl implements RecruitPostRepository {
  final RecruitPostDatasource remote;
  RecruitPostRepositoryImpl(this.remote);

  @override
  Future<RecruitPostEntity> createPost(String token, RecruitPostEntity post) async {
    final res = await remote.createPost(token, RecruitPostEntity.toPostModel(post));
    return RecruitPostEntity.toPostEntity(res);
  }

  @override
  Future<bool> deletePost(String token, String id) async {
    final res = await remote.deletePost(token, id);
    return res;
  }

  @override
  Future<Map<String, List<RecruitPostEntity>>> getPostInitData() async {
    final res = await remote.getPostsInitData();
    final List<RecruitPostEntity> favoritePosts = res['favoritePosts'] != null ?
    res['favoritePosts']!.map((e) => RecruitPostEntity.toPostEntity(e)).toList() : [];
    final List<RecruitPostEntity> posts = res['posts'] != null ?
    res['posts']!.map((e) => RecruitPostEntity.toPostEntity(e)).toList() : [];

    return {'favoritePosts': favoritePosts, 'posts': posts};
  }

  @override
  Future<RecruitPostEntity> getPostById(String token, String id) async {
    final res = await remote.getPostById(token, id);
    return RecruitPostEntity.toPostEntity(res);
  }

  @override
  Future<List<RecruitPostEntity>> getUserRecruitmentPosts(String token, String userId) async {
    final res = await remote.getUserRecruitmentPosts(token, userId);
    if(res.isEmpty){
      return [];
    }
    return res.map((e) => RecruitPostEntity.toPostEntity(e)).toList();
  }

  @override
  Future<List<RecruitPostEntity>> getPostByTitle(String title) {
    // TODO: implement getPostByTitle
    throw UnimplementedError();
  }

  @override
  Future<RecruitPostEntity> updatePost(String token, RecruitPostEntity post) async {
    final res = await remote.updatePost(token, RecruitPostEntity.toPostModel(post));
    return RecruitPostEntity.toPostEntity(res);
  }


  @override
  Future<List<RecruitPostEntity>> getPostPagination(int page) async {
    final res = await remote.getPostsPagination(page);
    return res.map((e) => RecruitPostEntity.toPostEntity(e)).toList();
  }
}