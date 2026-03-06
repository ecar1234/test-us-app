import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchasesManagements with ChangeNotifier {

  CustomerInfo? _customerInfo;
  CustomerInfo? get customerInfo => _customerInfo;


  Future<void> initializeRevenueCat() async {
    Purchases.setLogLevel(LogLevel.debug);// Platform-specific API keys
    late PurchasesConfiguration configuration;
    if (Platform.isIOS) {
      configuration = PurchasesConfiguration('appl_PEXNIkAbwtzuQdJdiSCwOawkOgx');
      debugPrint('[RevenueCat] Release Mode(IOS) Init');
    } else if (Platform.isAndroid) {
      configuration = PurchasesConfiguration('goog_iSxQflIhRkehjVWlyHwfGckiGEv');
      debugPrint('[RevenueCat] Release Mode(Android) Init');
    } else {
      throw UnsupportedError('Platform not supported');
    }

    await Purchases.configure(configuration);
    Purchases.addCustomerInfoUpdateListener((CustomerInfo customerInfo) {
      if(customerInfo.entitlements.all.values.first.isActive){
        _customerInfo = customerInfo;
        notifyListeners();
      }
    });
    _getCustomInfo();
  }
  Future<void> _getCustomInfo() async {
    final customerInfo = await Purchases.getCustomerInfo();
    if(customerInfo.entitlements.all.values.first.isActive){
      _customerInfo = customerInfo;
      notifyListeners();
    }
  }

  Future<List<Package>> getOfferings(String plan) async {
    try {
      final offerings = await Purchases.getOfferings();
      final packages = offerings.all[plan.toLowerCase()]!.availablePackages;
      // debugPrint("[Provider getOfferings] ${offering.toString()}");
      if (packages.isEmpty) {
        return [];
      }
      return packages;
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<void> purchase(Package packageToPurchase, {bool? isChangePackage = false}) async {
    try {
      PurchaseParams purchaseParam;
      if (Platform.isAndroid && isChangePackage == true) {
          purchaseParam = PurchaseParams.package(
            packageToPurchase,
            googleProductChangeInfo: GoogleProductChangeInfo(
              _customerInfo!.activeSubscriptions.first,
              prorationMode: GoogleProrationMode.immediateWithTimeProration
            )
          );
      }else {
        purchaseParam = PurchaseParams.package(packageToPurchase);
      }
      final result = await Purchases.purchase(purchaseParam);
      if (result.customerInfo.entitlements.all[packageToPurchase.identifier]?.isActive ?? false){
        _customerInfo = result.customerInfo;
        notifyListeners();
      }
    } on PlatformException catch(e){
      debugPrint(e.toString());
    }
  }

  Future<void> restore() async {}

}
