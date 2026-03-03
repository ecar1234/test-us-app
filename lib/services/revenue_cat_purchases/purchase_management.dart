import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchasesManagements with ChangeNotifier {

  Future<void> initializeRevenueCat() async {
    // Platform-specific API keys
    String apiKey;
    if (kDebugMode) {
      apiKey = 'test_wCgXlVymKCwqhhHIUuWPFzTzBAZ';
      debugPrint('[RevenueCat] Debug Mode Init');
    } else {
      if (Platform.isIOS) {
        apiKey = 'appe2797ce8fa';
        debugPrint('[RevenueCat] Release Mode(IOS) Init');
      } else if (Platform.isAndroid) {
        apiKey = 'app98cd0b4169';
        debugPrint('[RevenueCat] Release Mode(Android) Init');
      } else {
        throw UnsupportedError('Platform not supported');
      }
    }

    await Purchases.configure(PurchasesConfiguration(apiKey));
  }
}
