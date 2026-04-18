
import '../entities/purchase_entity.dart';

abstract class PurchaseRepository {
  Future<void> eventLog();
  Future<void> errorLog(String errorInfo);
  Future<void> refresh();
  Future<PurchaseEntity> verifyPurchaseIOS(String token, String userId, Map<String, String> req);
  Future<PurchaseEntity> verifyPurchaseAOS(String token, String userId, Map<String, String> req);
  Future<List<PurchaseEntity>> getPurchaseList(String token, String userId);
}