
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:test_us_app/data/models/user/user_model.dart';
import 'package:test_us_app/domain/entities/user_entity.dart';
import 'package:test_us_app/presentation/bloc/app_bloc/app_event.dart';
import 'package:test_us_app/presentation/bloc/auth_bloc/auth_state.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/base_post_bloc/base_post_bloc.dart';
import 'package:test_us_app/presentation/bloc/post_blocs/base_post_bloc/base_post_event.dart';
import 'package:test_us_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:test_us_app/presentation/bloc/user_bloc/user_event.dart';
import 'package:test_us_app/presentation/provider/user_provider.dart';
import 'package:test_us_app/services/revenue_cat_purchases/purchase_management.dart';

import '../../core/api_names.dart';
import '../../data/sharedPreferences/firebase_messaging_preference.dart';
import '../../presentation/bloc/app_bloc/app_bloc.dart';
import '../../presentation/bloc/purchase_bloc/purchase_bloc.dart';
import '../../presentation/bloc/purchase_bloc/purchase_event.dart';
import '../../presentation/provider/firebase_messaging_provider.dart';
import '../../presentation/provider/socket_provider.dart';

class AuthService {
  final _logger = Logger();
  final _firebasePref = FirebaseMessagingPreference.instance;


  Future<void> loginCompletionHandler (BuildContext context, AuthState state) async {
    final user = state.user!;
    final token = state.token!;

    context.read<UserProvider>().autoLogin(token, user);
    context.read<BasePostBloc>().add(RequestUserInItDataEvent(token, user.id!));
    context.read<AppBloc>().add(RequestMyApplicationsEvent(token, user.id!));
    context.read<PurchasesManagements>().login(user.id!);
    if(user.method != AuthType.email){
      context.read<UserBloc>().add(RequestUserDataEvent(token, user.id!));
    }
    _fcmTokenHandler(context, token, user);
    _socketInitialize(context, state);
  }
  Future<void> _fcmTokenHandler(BuildContext context, String token, UserEntity user) async {
    final deviceType = Platform.isAndroid ? 'android' : 'ios';
    final userBloc = context.read<UserBloc>();
    final firebaseProvider = context.read<FirebaseMessagingProvider>();

    firebaseProvider.getNotification();

    String? messagingToken = await _firebasePref.getFirebaseToken();
    if (messagingToken == null) {
      messagingToken = await FirebaseMessaging.instance.getToken();
      if (messagingToken != null) {
        userBloc.add(CreateFirebaseTokenEvent(token, messagingToken, user.id, deviceType));
        firebaseProvider.setFirebaseToken(messagingToken);
      }
    } else {
      final fmcToken = await FirebaseMessaging.instance.getToken();
      if (fmcToken != null) {
        userBloc.add(UpdateFirebaseTokenEvent(token, fmcToken, user.id, deviceType));
        firebaseProvider.setFirebaseToken(fmcToken);
      }
    }
  }
  Future<void> _socketInitialize(BuildContext context, AuthState state)async{
    final socket = context.read<SocketProvider>();
    String host = kDebugMode ? Host.baseDevUrl : Host.baseProdUrl;
    socket.initializeSocket(host, state.token!);
  }
}