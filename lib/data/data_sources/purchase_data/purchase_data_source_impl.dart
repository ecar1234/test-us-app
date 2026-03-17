

import 'package:flutter/material.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:test_us_app/core/api_names.dart';
import 'package:test_us_app/core/net_driver.dart';
import 'package:test_us_app/data/data_sources/purchase_data/purchase_data_source.dart';

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
  Future<void> refresh(CustomerInfo info) {
    // TODO: implement refresh
    throw UnimplementedError();
  }

}