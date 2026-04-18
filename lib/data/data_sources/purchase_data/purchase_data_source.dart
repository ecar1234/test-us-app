
import '../../models/purchase/purchase_model.dart';

abstract class PurchaseDataSource {
  Future<void> eventLog(String info);
  Future<void> errorLog(String errorInfo);
  Future<void> refresh();
  Future<PurchaseModel> verifyPurchaseIOS(String token, String userId, Map<String, String> req);
  Future<PurchaseModel> verifyPurchaseAOS(String token, String userId, Map<String, String> req);
  Future<List<PurchaseModel>> getPurchaseList(String token, String userId);
}