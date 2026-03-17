
import 'package:purchases_flutter/models/customer_info_wrapper.dart';

abstract class PurchaseRepository {
  Future<void> eventLog(String info);
  Future<void> errorLog(String errorInfo);
  Future<void> refresh(CustomerInfo info);
}