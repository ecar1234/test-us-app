import 'package:image_picker/image_picker.dart';
import 'package:test_us_app/data/models/image/image_model.dart';
import 'package:test_us_app/data/models/post/recruit_post_model.dart';
import 'package:test_us_app/domain/entities/promotion_post_entity.dart';
import 'package:test_us_app/domain/entities/recruit_post_entity.dart';

import '../../domain/entities/image_entity.dart';
import '../../domain/repositories/recruit_post_repository.dart';
import '../data_sources/post_data/recruit_post_datasource.dart';
import '../models/post/promotion_post_model.dart';

class RecruitPostRepositoryImpl implements RecruitPostRepository {
  final RecruitPostDatasource remote;
  RecruitPostRepositoryImpl(this.remote);

  @override
  Future<RecruitPostEntity> createPost(String token, RecruitPostEntity post, List<XFile> images) async {
    final res = await remote.createPost(token, RecruitPostEntity.toPostModel(post), images);
    return RecruitPostEntity.toPostEntity(res);
  }

  @override
  Future<RecruitPostEntity> updatePost(String token, RecruitPostEntity post, List<XFile> images, List<ImageEntity> oldImages) async {
    final oldImagesModel = oldImages.map<ImageModel>((e) => ImageEntity.toImageModel(e)).toList();
    final newPost = RecruitPostEntity.toPostModel(post);
    final res = await remote.updatePost(token, newPost, images, oldImagesModel);
    return RecruitPostEntity.toPostEntity(res);
  }

  @override
  Future<bool> deletePost(String token, String id) async {
    final res = await remote.deletePost(token, id);
    return res;
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
  Future<List<RecruitPostEntity>> getPostPagination(int page) async {
    final res = await remote.getPostsPagination(page);
    return res.map((e) => RecruitPostEntity.toPostEntity(e)).toList();
  }
}