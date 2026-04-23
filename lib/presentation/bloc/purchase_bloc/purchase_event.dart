
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:test_us_app/domain/entities/purchase_entity.dart';

class PurchaseEvent {}

class PurchaseInit extends PurchaseEvent {
  final String token;
  PurchaseInit(this.token);
}

class PurchaseOfferings extends PurchaseEvent {
  PurchaseOfferings();
}

class RequestAosNewPurchase extends PurchaseEvent {
  final ProductDetails product;

  RequestAosNewPurchase({required this.product});
}
class PrepareUpdateRestorePurchase extends PurchaseEvent {
  PrepareUpdateRestorePurchase();
}
class RequestAosUpdatePurchase extends PurchaseEvent {
  final ProductDetails product;
  final String productId;
  final PurchaseDetails old;

  RequestAosUpdatePurchase({required this.product, required this.productId, required this.old});
}
class RequestIosPurchase extends PurchaseEvent {
  final ProductDetails product;

  RequestIosPurchase({required this.product});
}

class RequestRestorePurchase extends PurchaseEvent {
  RequestRestorePurchase();
}

class PurchaseOnHandlerEvent extends PurchaseEvent {
  final String token;
  final List<PurchaseDetails> purchaseDetailsList;
  PurchaseOnHandlerEvent(this.token, this.purchaseDetailsList);
}

class VerificationPurchase extends PurchaseEvent {
  final String token;
  final String userId;
  final PurchaseDetails details;

  VerificationPurchase({required this.token, required this.userId, required this.details});
}

class RequestUserPurchaseInfo extends PurchaseEvent {
  final String token;
  final String userId;

  RequestUserPurchaseInfo({required this.token, required this.userId});
}

class PurchaseStateInitEvent extends PurchaseEvent {
  PurchaseStateInitEvent();
}


