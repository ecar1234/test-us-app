
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:test_us_app/domain/entities/purchase_entity.dart';

enum PurchaseProgressState {
  serviceStart,
  initCompleted,
  starting,
  loading,
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
  final List<Package>? packages;
  GetOfferingCompletedState({this.packages}): super(state: PurchaseProgressState.success);
}
class PurchaseCompletedState extends PurchaseState{
  final PurchaseEntity entity;
  PurchaseCompletedState(this.entity): super(state: PurchaseProgressState.success);
}
class PurchaseUpdateCompletedState extends PurchaseState{
  final PurchaseEntity entity;
  final int grade;
  PurchaseUpdateCompletedState(this.entity, this.grade): super(state: PurchaseProgressState.success);
}