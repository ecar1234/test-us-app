import 'package:image_picker/image_picker.dart';

import '../entities/image_entity.dart';
import '../entities/recruit_post_entity.dart';
import '../repositories/recruit_post_repository.dart';

class RecruitPostUseCase {
  final RecruitPostRepository repository;

  RecruitPostUseCase(this.repository);

  Future<Map<String, List<RecruitPostEntity>>> getPostInitData() async {
    final initData = await repository.getPostInitData();
    return {'favoritePosts': initData['favoritePosts']!, 'posts': initData['posts']!};
  }

  Future<RecruitPostEntity> getPostById(String token, String id) async {
    final res = await repository.getPostById(token, id);
    return res;
  }

  Future<List<RecruitPostEntity>> getUserRecruitmentPosts(String token, String userId) async {
    final res = await repository.getUserRecruitmentPosts(token, userId);
    return res;
  }

  Future<RecruitPostEntity> updatePost(String token, RecruitPostEntity post) async {
    final res = await repository.updatePost(token, post);
    return res;
  }

  Future<bool> deletePost(String token, String id) async {
    final res = await repository.deletePost(token, id);
    return res;
  }

  Future<RecruitPostEntity> createPost(String token, RecruitPostEntity post) async {
    final res = await repository.createPost(token, post);
    return res;
  }

  // Future<PostEntity> getPostById(String id) async {
  //   final res = await repository.getPostById(id);
  //   return res;
  // }
  Future<List<RecruitPostEntity>> getPostByTitle(String title) async {
    final res = await repository.getPostByTitle(title);
    return res;
  }

  Future<List<RecruitPostEntity>> getPostPagination(int page) async {
    final res = await repository.getPostPagination(page);
    return res;
  }
}
