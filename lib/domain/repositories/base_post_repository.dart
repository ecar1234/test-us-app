

abstract class BasePostRepository {
  Future<Map<String, dynamic>> getPostInitData();
  Future<Map<String,dynamic>> getUserInitData (String token, String id);
}