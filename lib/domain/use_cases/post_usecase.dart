
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class PostUseCase {
  final PostRepository repository;
  PostUseCase(this.repository);

  Future<List<List<PostEntity>>> getPostInitData() async {
    final res = await repository.getPostInitData();
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
  Future<bool> updatePost(String token, PostEntity post) async {
    final res = await repository.updatePost(token, post);
    return res;
  }
  Future<bool> deletePost(String token, String id) async {
    final res = await repository.deletePost(token, id);
    return res;
  }
  Future<bool> createPost(String token, PostEntity post) async {
    final res = await repository.createPost(token, post);
    return res;
  }
  Future<PostEntity> getPostById(String id) async {
    final res = await repository.getPostById(id);
    return res;
  }
  Future<List<PostEntity>> getPostByTitle(String title) async {
    final res = await repository.getPostByTitle(title);
    return res;
  }
  Future<List<PostEntity>> getPostPagination(int page) async {
    final res = await repository.getPostPagination(page);
    return res;
  }
}