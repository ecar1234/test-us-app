import '../../domain/entities/promotion_post_entity.dart';
import '../../domain/entities/recruit_post_entity.dart';
import '../../domain/repositories/base_post_repository.dart';
import '../data_sources/post_data/base_post_datasource.dart';
import '../models/post/recruit_post_model.dart';

class BasePostRepositoryImpl implements BasePostRepository {
  final BasePostDataSource remote;

  BasePostRepositoryImpl(this.remote);


  @override
  Future<Map<String,dynamic>> getUserInitData(String token, String id) async {
    final res = await remote.getUserInitData(token, id);
    final recruitPost = res['recruit'].map<RecruitPostEntity>((e) => RecruitPostEntity.toPostEntity(e)).toList();
    final promotionPosts = res['promotion'].map<PromotionPostEntity>((e) => PromotionPostEntity.toEntity(e)).toList();
    return{
      'recruitPosts':recruitPost,
      'promotionPosts':promotionPosts
    };
  }

  @override
  Future<Map<String, dynamic>> getPostInitData() async {
    final res = await remote.getPostsInitData();
    final favoritePosts = res['favorite']!.map((e) {
      if(e.postType == 'RecruitmentPostEntity') {
        return RecruitPostEntity.toPostEntity(e);
      }else {
        return PromotionPostEntity.toEntity(e);
      }
    }).toList();

    final recruitPosts = res['recruit']!.map<RecruitPostEntity>((e) => RecruitPostEntity.toPostEntity(e)).toList();
    final promotionPosts = res['promotion']!.map<PromotionPostEntity>((e) => PromotionPostEntity.toEntity(e)).toList();


    return { 'favoritePosts': favoritePosts, 'recruitPosts': recruitPosts, 'promotionPosts': promotionPosts };
  }
}