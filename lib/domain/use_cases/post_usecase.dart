
import '../entities/post_entity.dart';
import '../repositories/post_repository.dart';

class PostUseCase {
  final PostRepository repository;
  PostUseCase(this.repository);

  Future<List<PostEntity>> getPostAllData() async {
    final res = await repository.getPostAllData();
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
  Future<Map<String, dynamic>> createPost(String token, PostEntity post) async {
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
}