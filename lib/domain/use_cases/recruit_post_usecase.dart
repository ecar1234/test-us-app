import 'package:image_picker/image_picker.dart';

import '../entities/image_entity.dart';
import '../entities/recruit_post_entity.dart';
import '../repositories/recruit_post_repository.dart';

class RecruitPostUseCase {
  final RecruitPostRepository repository;

  RecruitPostUseCase(this.repository);

  Future<RecruitPostEntity> getPostById(String token, String id) async {
    final res = await repository.getPostById(token, id);
    return res;
  }

  Future<List<RecruitPostEntity>> getUserRecruitmentPosts(String token, String userId) async {
    final res = await repository.getUserRecruitmentPosts(token, userId);
    return res;
  }

  Future<RecruitPostEntity> updatePost(String token, RecruitPostEntity post, List<XFile> images, List<ImageEntity> oldImages) async {
    final res = await repository.updatePost(token, post, images, oldImages);
    return res;
  }

  Future<bool> deletePost(String token, String id) async {
    final res = await repository.deletePost(token, id);
    return res;
  }

  Future<RecruitPostEntity> createPost(String token, RecruitPostEntity post, List<XFile> images) async {
    final res = await repository.createPost(token, post, images);
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
