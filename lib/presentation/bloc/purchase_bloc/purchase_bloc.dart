import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logger/logger.dart';

import 'package:test_us_app/domain/use_cases/purchase_usecase.dart';
import 'package:test_us_app/presentation/bloc/purchase_bloc/purchase_event.dart';
import 'package:test_us_app/presentation/bloc/purchase_bloc/purchase_state.dart';

import '../../../domain/entities/product_entity.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final logger = Logger();
  final InAppPurchase _inAppPurchase;

  PurchaseBloc(PurchaseUseCase purchaseUseCase, this._inAppPurchase)
      : super(PurchaseState(state: PurchaseProgressState.serviceStart)) {

    on<PurchaseInit>((event, emit) async {
      final bool available = await _inAppPurchase.isAvailable();
      if (!available) {
        emit(PurchaseState(state: PurchaseProgressState.error, message: '구매 서비스를 사용할 수 없습니다.'));
        debugPrint('[Purchase] purchase service is not available');
        return;
      }
      late StreamSubscription<List<PurchaseDetails>> subscription;
      final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
      subscription = purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
        add(PurchaseOnHandlerEvent(event.token, purchaseDetailsList));
      }, onDone: () {
        subscription.cancel();
      }, onError: (Object error) {
        // handle error here.
      });
      emit(PurchaseInitCompletedState());
      debugPrint('[Purchase] stream listener initialized');
    });

    on<PurchaseOfferings>((event, emit) async {
      emit(PurchaseState(state: PurchaseProgressState.loading));
      debugPrint('[Purchase] offering loading....');

      try {
        final products = await purchaseUseCase.getProducts();
        if(products.isEmpty){
          emit(PurchaseState(
              state: PurchaseProgressState.error, message: '상품 정보를 가져오는데 실패 했습니다.'));
          debugPrint('[Purchase] purchase service is not available');
          return;
        }

        emit(GetOfferingCompletedState(products));
        debugPrint('[Purchase] offering loaded');
      } on Exception catch (e) {
        emit(PurchaseState(state: PurchaseProgressState.error, message: e.toString()));
        debugPrint('[Purchase] offering loading failed');
      }
    });

    on<RequestAosNewPurchase>((event, emit) async {
      final res = await purchaseUseCase.newPurchaseByAos(event.product);
      if (!res) {
        emit(PurchaseState(state: PurchaseProgressState.error, message: '구매에 실패하였습니다.'));
        debugPrint('[Purchase] purchase failed');
        return;
      }
      emit(PurchasePendingState());
      debugPrint('[Purchase] PurchasePendingState');
    });

    on<PrepareUpdateRestorePurchase>((event, emit) async {
      await purchaseUseCase.prepareUpdate();
      emit(UpdateLoadingState());
      debugPrint('[Purchase] prepare update : start restore');
    });

    on<RequestAosUpdatePurchase>((event, emit) async {
      final res = await purchaseUseCase.purchaseUpdateByAos(event.product, event.productId, event.old);
      if(!res){
        emit(PurchaseState(state: PurchaseProgressState.error, message: '[Purchase AOS] 업데이트 실패하였습니다.'));
        debugPrint('[Purchase] purchase failed');
        return;
      }
      emit(PurchasePendingState());
      debugPrint('[Purchase] PurchasePendingState');
    });

    on<RequestIosPurchase>((event, emit) async {
      try {
        final res = await purchaseUseCase.purchaseByIos(event.product);
        if (!res) {
          emit(PurchaseState(state: PurchaseProgressState.error, message: '구매에 실패하였습니다.'));
          debugPrint('[Purchase] purchase failed');
          return;
        }
        emit(PurchasePendingState());
        debugPrint('[Purchase] PurchasePendingState');
      } on Exception catch (e) {
        debugPrint("[Purchase Exception] IOS purchase ${e.toString()}");
        emit(PurchaseState(state: PurchaseProgressState.error, message: e.toString()));
        debugPrint('[Purchase] purchase error');
      }
    });

    on<RequestRestorePurchase>((event, emit) async {
      await _inAppPurchase.restorePurchases();
    });

    on<VerificationPurchase>((event, emit) async {
      emit(PurchaseState(state: PurchaseProgressState.loading));
      debugPrint('[Purchase] verification starting....');
      try {
        final res = await purchaseUseCase.verifyPurchase(event.token, event.userId, event.details);
        if (res.id == 500 || res.id == 400) {
          emit(PurchaseState(state: PurchaseProgressState.error, message: '구매 검증 실패.'));
          debugPrint('[Purchase] verification failed');
          return;
        } else if(res.id == 204){
          emit(PurchaseState(state: PurchaseProgressState.failed, message: '취소 또는 만료된 구독입니다.'));
          return;
        }
        emit(PurchaseCompletedByServerState(res));
        debugPrint('[Purchase] verification && purchase completed');
      } on Exception catch (e) {
        emit(PurchaseState(state: PurchaseProgressState.error, message: e.toString()));
        debugPrint('[Purchase] verification failed');
      }
    });

    on<RequestUserPurchaseInfo>((event, emit) async {
      try {
        emit(PurchaseState(state: PurchaseProgressState.loading));
        debugPrint('[Purchase] user purchase info loading....');
        final res = await purchaseUseCase.getPurchaseList(event.token, event.userId);
        emit(GetUserPurchaseInfoCompletedState(res));
      } on Exception catch (e) {
        emit(PurchaseState(state: PurchaseProgressState.error, message: e.toString()));
        debugPrint('[Purchase] user purchase info loading failed');
      }
    });

    on<PurchaseOnHandlerEvent>((event, emit) async {
      for (final PurchaseDetails purchaseDetails in event.purchaseDetailsList) {
        if (purchaseDetails.status == PurchaseStatus.pending) {
          emit(PurchaseState(state: PurchaseProgressState.pending));
          debugPrint('[Purchase] purchase state update to pending');
        } else {
          if (purchaseDetails.status == PurchaseStatus.error) {
            emit(PurchaseState(state: PurchaseProgressState.error, message: purchaseDetails.error?.message));
            debugPrint('[Purchase] purchase state update to error');
            debugPrint('[Purchase]${purchaseDetails.error?.message}');
          } else if (purchaseDetails.status == PurchaseStatus.purchased) {
            emit(PurchaseCompletedState(details: purchaseDetails));
            debugPrint('[Purchase] PurchaseCompletedState');
          } else if (purchaseDetails.status == PurchaseStatus.restored) {
            emit(PurchaseRestoreCompletedState(details: purchaseDetails));
            debugPrint('[Purchase] PurchaseRestoreCompletedState');
          }

        }
      }
    });

    on<PurchaseStateInitEvent>((event, emit) async {
      emit(PurchaseState(state: PurchaseProgressState.initCompleted));
    });
    on<IosPurchaseTestEvent>((event, emit) async {
      final res = await purchaseUseCase.eventLog(event.transactionMock);
    });
  }
}
