

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

import '../../domain/entities/firebase_messaging_entity.dart';
import '../../presentation/bloc/user_bloc/user_bloc.dart';
import '../../presentation/bloc/user_bloc/user_event.dart';
import '../../presentation/provider/firebase_messaging_provider.dart';
import '../../presentation/provider/user_provider.dart';

class MessagingService {
  static final MessagingService _instance = MessagingService._();
  factory MessagingService() => _instance;
  MessagingService._();

  late FirebaseMessagingProvider provider;

  void init(FirebaseMessagingProvider provider){
    provider = provider;
  }

  Future<void> saveNotification(FirebaseMessagingEntity notification) async {
    await provider.saveNotification(notification);
  }


}