
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:test_us_app/domain/entities/purchase_entity.dart';
import 'package:test_us_app/presentation/bloc/purchase_bloc/purchase_event.dart';
import 'package:test_us_app/presentation/bloc/purchase_bloc/purchase_state.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 10000,
    )
  );
  PurchaseBloc() : super(PurchaseState(state: PurchaseProgressState.serviceStart)) {
    on<PurchaseInit> ((event, emit) async {
      emit(PurchaseState(state: PurchaseProgressState.loading));
      logger.i('[Purchase] initializeRevenueCat start');
      try {
        late PurchasesConfiguration configuration;
        if (Platform.isIOS) {
          configuration = PurchasesConfiguration('appl_tRVsZtlDmNwTzkGftXvkEynXymB');
          logger.i('[RevenueCat] Release Mode(IOS) Init');
        } else if (Platform.isAndroid) {
          configuration = PurchasesConfiguration('goog_fPnfMAsYqlmIVGbUxdMkVgYJDUU');
          logger.i('[RevenueCat] Release Mode(Android) Init');
        } else {
          throw UnsupportedError('Platform not supported');
        }

        await Purchases.configure(configuration);
        emit(PurchaseInitCompletedState());
        logger.i('[Purchase] initializeRevenueCat success');
      } catch (e) {
        emit(PurchaseState(state: PurchaseProgressState.error, message: e.toString()));
        logger.e('[Purchase] initializeRevenueCat error : $e');
      }
    });
    on<PurchaseOfferings>((event, emit) async {
      emit(PurchaseState(state: PurchaseProgressState.loading));
      logger.i('[Purchase] getOfferings start');
      try {
        final offerings = await Purchases.getOfferings();
        final offer = '${event.plan.toLowerCase()}-default';
        final packages = offerings.all[offer]!.availablePackages;
        if (packages.isEmpty) {
          emit(GetOfferingCompletedState(packages: []));
          logger.i('[Purchase] getOfferings empty');
          return;
        }
        emit(GetOfferingCompletedState(packages: packages.reversed.toList()));
        logger.i('[Purchase] getOfferings success : ${packages.length}');
      } catch (e) {
        emit(PurchaseState(state: PurchaseProgressState.error, message: e.toString()));
        logger.e('[Purchase] getOfferings error : $e');
      }
    });
    on<RequestNewPurchase>((event, emit) async {
      emit(PurchaseState(state: PurchaseProgressState.loading));
      logger.i('[Purchase] purchase start');
        try {
            final purchaseParam = PurchaseParams.package(event.package);
            final result = await Purchases.purchase(purchaseParam);
            final activeItem = result.customerInfo.entitlements.active.values.where((item) => item.isActive).toList();
            if (activeItem.isNotEmpty){
              if(activeItem.length == 1){
                final res = PurchaseEntity.toEntity(activeItem.first);
                emit(PurchaseCompletedState(res));
                logger.i('[Purchase] purchase success');
              }else {
                emit(PurchaseState(state: PurchaseProgressState.error, message: '활성화 상품이 하나 이상입니다.'));
                logger.i('[Purchase] purchase error');
              }
            }else{
              emit(PurchaseState(state: PurchaseProgressState.failed, message: '활성화 상품이 존재하지 않습니다.'));
              logger.i('[Purchase] purchase failed');
            }

        } on PlatformException catch(e){
          emit(PurchaseState(state: PurchaseProgressState.error, message: e.toString()));
          logger.e('[Purchase] purchase error : $e');
        }
    });
    on<RequestUpdatePurchase>((event, emit) async {
      try {
        PurchaseParams purchaseParam;
        final grade = _checkProrationMode(event.old!, event.package); // 0: none, 1: upgrade, -1 : downgrade

        if(Platform.isAndroid){
          final prorationMode = grade == 1 ? GoogleProrationMode.deferred
              // : (grade == -1 ? GoogleProrationMode.immediateWithTimeProration : GoogleProrationMode.immediateAndChargeFullPrice);
              : (grade == -1 ? GoogleProrationMode.immediateAndChargeFullPrice : GoogleProrationMode.immediateAndChargeFullPrice);
          purchaseParam = PurchaseParams.package(
              event.package,
              googleProductChangeInfo: GoogleProductChangeInfo(
                  "purchase:${event.old.planId}",
                  prorationMode: prorationMode
              )
          );
        }else {
          purchaseParam = PurchaseParams.package(event.package);
        }
        final result = await Purchases.purchase(purchaseParam);
        final activeItem = result.customerInfo.entitlements.active.values.where((item) => item.isActive).toList();
        if (activeItem.isNotEmpty){
          if(activeItem.length == 1){
            final res = PurchaseEntity.toEntity(activeItem.first);
            emit(PurchaseUpdateCompletedState(res, grade));
            logger.i('[Purchase] purchase update success : gradeCode : $grade (0: none, 1: upgrade, -1 : downgrade)');
            return;
          }else {
            emit(PurchaseState(state: PurchaseProgressState.error, message: '활성화 상품이 하나 이상입니다.'));
            logger.i('[Purchase] purchase error');
            return;
          }
        }else{
          emit(PurchaseState(state: PurchaseProgressState.failed, message: '활성화 상품이 존재하지 않습니다.'));
          logger.i('[Purchase] purchase failed');
          return;
        }
      } on PlatformException catch (e) {
        emit(PurchaseState(state: PurchaseProgressState.error, message: '활성화 상품이 하나 이상입니다.'));
        logger.i('[Purchase] purchase error');
      }
    });

    on<RequestRestorePurchase>((event, emit) async {
      emit(PurchaseState(state: PurchaseProgressState.loading));
      logger.i('[Purchase] restore start');
      try {
        final restore = await Purchases.restorePurchases();
        if(restore.entitlements.active.isEmpty){
          emit(PurchaseState(state: PurchaseProgressState.failed, message: '구매 내역이 없습니다.'));
          logger.i('[Purchase] restore failed');
          return;
        }
        final activeItem = restore.entitlements.active.values.where((item) => item.isActive).toList();
        final res = PurchaseEntity.toEntity(activeItem.first);
        emit(PurchaseRestoreCompletedState(res));
        logger.i('[Purchase] restore success');
      } on PlatformException catch (e) {
        emit(PurchaseState(state: PurchaseProgressState.error, message: e.toString()));
        logger.e('[Purchase] restore error : $e');
      }
    });
  }

  int _checkProrationMode(PurchaseEntity entity, Package newPackage) {
    // 2. 현재 플랜과 새 플랜의 가중치 비교
    int currentPlan = 0; // 0: none, 1: standard, 2: premium
    int newPlan = 0; // 0: 0: none, 1: standard, 2: premium

    if(entity.plan == 'standard') {
      currentPlan = 1;
    }else {
      currentPlan = 2;
    }
    if(newPackage.storeProduct.presentedOfferingContext?.offeringIdentifier.split('-')[0]=='standard') {
      newPlan = 1;
    }else {
      newPlan = 2;
    }

    return currentPlan - newPlan;
  }
}