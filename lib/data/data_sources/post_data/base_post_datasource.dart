
abstract class BasePostDataSource {
  Future<Map<String, List<dynamic>>> getPostsInitData();
  Future<Map<String,dynamic>> getUserInitData (String token, String id);
}