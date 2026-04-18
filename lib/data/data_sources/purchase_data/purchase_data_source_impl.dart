

import 'package:flutter/material.dart';
import 'package:test_us_app/core/api_names.dart';
import 'package:test_us_app/core/net_driver.dart';
import 'package:test_us_app/data/data_sources/purchase_data/purchase_data_source.dart';

import '../../models/purchase/purchase_model.dart';

class PurchaseDataSourceImpl implements PurchaseDataSource {
  final NetDriver _netDriver;
  PurchaseDataSourceImpl(this._netDriver);

  @override
  Future<void> errorLog(String errorInfo) async {
    final res = await _netDriver.requestPostJson('', PurchaseApi.errorLog, {'errorData' : errorInfo});
    if(res['status'] == 200){
      debugPrint('[Purchase Debug] errorLog delivery success');
    } else {
      debugPrint('[Purchase Debug] errorLog delivery failed');
    }
  }

  @override
  Future<void> eventLog(String info) async {
    final res = await _netDriver.requestPostJson('', PurchaseApi.eventLog, {'eventData' : info});
    if(res['status'] == 200){
      debugPrint('[Purchase Debug] eventLog delivery success');
    } else {
      debugPrint('[Purchase Debug] eventLog delivery failed');
    }
  }

  @override
  Future<void> refresh() {
    // TODO: implement refresh
    throw UnimplementedError();
  }

  @override
  Future<PurchaseModel> verifyPurchaseIOS(String token, String userId, Map<String, String> req) async {
    final res = await _netDriver.requestPostJson(token, PurchaseApi.verifyPurchaseIOS, req);
    if(res['status'] == 200){
      debugPrint('[Purchase Debug] verifyPurchase delivery success');
      return PurchaseModel.fromJson(res['subscribe']);
    } else {
      debugPrint('[Purchase Debug] verifyPurchase delivery failed');
      return PurchaseModel();
    }
  }
  @override
  Future<PurchaseModel> verifyPurchaseAOS(String token, String userId, Map<String, String> req) async {
    final res = await _netDriver.requestPostJson(token, PurchaseApi.verifyPurchaseAOS, req);
    if(res['status'] == 200){
      debugPrint('[Purchase Debug] verifyPurchase delivery success');
      return PurchaseModel.fromJson(res['subscribe']);
    } else {
      debugPrint('[Purchase Debug] verifyPurchase delivery failed');
      return PurchaseModel();
    }
  }

  @override
  Future<List<PurchaseModel>> getPurchaseList(String token, String userId) async {
    final res = await _netDriver.requestGetJson(token, PurchaseApi.getPurchaseList, param : userId);
    if(res['status'] == 200){
      debugPrint('[Purchase Debug] getPurchaseList delivery success');
      return (res['subscribes'] as List).map((e) => PurchaseModel.fromJson(e)).toList();
    } else {
      debugPrint('[Purchase Debug] getPurchaseList delivery failed');
      return [];
    }
  }

}