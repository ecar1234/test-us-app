import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:test_us_app/domain/use_cases/user_usecase.dart';

import '../../domain/entities/firebase_messaging_entity.dart';
import '../../presentation/provider/firebase_messaging_provider.dart';
import '../../presentation/provider/user_provider.dart';

class MessagingService {
  static final MessagingService _instance = MessagingService._();
  factory MessagingService() => _instance;
  MessagingService._();

  final FirebaseMessagingProvider provider = GetIt.I.get<FirebaseMessagingProvider>();
  late UserProvider userProvider;


  void init(FirebaseMessagingProvider provider){
    provider = provider;
  }

  Future<void> saveNotification(FirebaseMessagingEntity notification) async {
    await provider.saveNotification(notification);
  }
  Future<void> saveToken(String messagingToken) async {
    await provider.setFirebaseToken(messagingToken);
    final token = userProvider.token ?? "";
    final userId = userProvider.user?.id ?? "";
    final deviceType = Platform.isAndroid ? 'android' : 'ios';
    if(provider.token == null){
      await GetIt.I.get<UserUseCase>().createFirebaseToken(token, messagingToken, userId, deviceType);
    }else {
      await GetIt.I.get<UserUseCase>().updateFirebaseToken(token, messagingToken, userId, deviceType);
    }
  }
}