import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:test_us_app/domain/entities/purchase_entity.dart';

import '../../../domain/entities/product_entity.dart';

enum PurchaseProgressState {
  serviceStart,
  initCompleted,
  starting,
  loading,
  pending,
  success,
  error,
  failed
}

class PurchaseState {
  final PurchaseProgressState state ;
  final String? message;

  PurchaseState({this.state = PurchaseProgressState.loading, this.message});
}
class PurchaseInitCompletedState extends PurchaseState{
  PurchaseInitCompletedState(): super(state: PurchaseProgressState.initCompleted);
}
class GetOfferingCompletedState extends PurchaseState{
  final List<ProductEntity> products;
  GetOfferingCompletedState(this.products): super(state: PurchaseProgressState.success);
}
class PurchasePendingState extends PurchaseState{
  PurchasePendingState(): super(state: PurchaseProgressState.pending);
}
class PurchaseCompletedState extends PurchaseState{
  final PurchaseDetails details;
  PurchaseCompletedState({required this.details}): super(state: PurchaseProgressState.success);
}
class PurchaseCompletedByServerState extends PurchaseState{
  final PurchaseEntity entity;
  PurchaseCompletedByServerState(this.entity): super(state: PurchaseProgressState.pending);
}
class UpdateLoadingState extends PurchaseState {
  UpdateLoadingState(): super(state: PurchaseProgressState.pending);
}
class PurchaseUpdateCompletedState extends PurchaseState{
  final PurchaseEntity entity;
  final int grade;
  PurchaseUpdateCompletedState(this.entity, this.grade): super(state: PurchaseProgressState.success);
}
class PurchaseRestoreCompletedState extends PurchaseState{
  final PurchaseDetails details;
  PurchaseRestoreCompletedState(this.details): super(state: PurchaseProgressState.success);
}

class GetUserPurchaseInfoCompletedState extends PurchaseState{
  final List<PurchaseEntity> subscribeList;

  GetUserPurchaseInfoCompletedState(this.subscribeList): super(state: PurchaseProgressState.success);
}