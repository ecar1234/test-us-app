import 'package:test_us_app/data/data_sources/purchase_data/purchase_data_source.dart';
import 'package:test_us_app/domain/repositories/purchase_repository.dart';

import '../../domain/entities/purchase_entity.dart';

class PurchaseRepositoryImpl implements PurchaseRepository{
  final PurchaseDataSource _remote;
  PurchaseRepositoryImpl(this._remote);

  @override
  Future<void> errorLog(String errorInfo) async {
    await _remote.errorLog(errorInfo);
  }

  @override
  Future<void> eventLog(String testWord) async {
    await _remote.eventLog(testWord);
  }

  @override
  Future<void> refresh() async {
    await _remote.refresh();
  }

  @override
  Future<PurchaseEntity> verifyPurchaseIOS(String token, String userId, Map<String, String> req) async {
    final res = await _remote.verifyPurchaseIOS(token, userId, req);
    if(res.id == 204){
      return PurchaseEntity(id: 204);
    } else if(res.id == 500){
      return PurchaseEntity(id: 500);
    }
    return PurchaseEntity.toEntity(res);
  }
  @override
  Future<PurchaseEntity> verifyPurchaseAOS(String token, String userId, Map<String, String> req) async {
    final res = await _remote.verifyPurchaseAOS(token, userId, req);
    if(res.id == 204){
      return PurchaseEntity(id: 204);
    } else if(res.id == 500){
      return PurchaseEntity(id: 500);
    }
    return PurchaseEntity.toEntity(res);
  }

  @override
  Future<List<PurchaseEntity>> getPurchaseList(String token, String userId) async {
    final res = await _remote.getPurchaseList(token, userId);
    if(res.isEmpty){
      return [];
    }
    return res.map((e) => PurchaseEntity.toEntity(e)).toList();
  }

}