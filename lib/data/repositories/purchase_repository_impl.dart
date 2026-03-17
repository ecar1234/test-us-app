

import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:test_us_app/data/data_sources/purchase_data/purchase_data_source.dart';
import 'package:test_us_app/domain/repositories/purchase_repository.dart';

class PurchaseRepositoryImpl implements PurchaseRepository{
  final PurchaseDataSource _remote;
  PurchaseRepositoryImpl(this._remote);

  @override
  Future<void> errorLog(String errorInfo) async {
    await _remote.errorLog(errorInfo);
  }

  @override
  Future<void> eventLog(String info) async {
    await _remote.eventLog(info);
  }

  @override
  Future<void> refresh(CustomerInfo info) async {
    await _remote.refresh(info);
  }

}