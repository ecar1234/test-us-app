

import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:test_us_app/domain/entities/purchase_entity.dart';

class PurchaseEvent {}

class PurchaseInit extends PurchaseEvent {
  PurchaseInit();
}

class PurchaseOfferings extends PurchaseEvent {
  final String plan;
  PurchaseOfferings(this.plan);
}

class RequestNewPurchase extends PurchaseEvent {
  final Package package;

  RequestNewPurchase(this.package);
}
class RequestUpdatePurchase extends PurchaseEvent {
  final Package package;
  final PurchaseEntity old;

  RequestUpdatePurchase(this.package, this.old);
}

