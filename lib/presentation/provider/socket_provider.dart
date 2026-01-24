

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:test_us_app/data/models/message/message_model.dart';
import 'package:test_us_app/services/socket/socket_io_client.dart';

import '../../domain/entities/message_entity.dart';


final GetIt _getIt = GetIt.instance;

class SocketProvider with ChangeNotifier {
  final _socket = _getIt.get<SocketIoClient>();

  List<MessageEntity> _messages = [];


  // 앱 진입 시 혹은 설정 화면에서 호출
  void initializeSocket(String host, String token) {
    _socket.init(host, token);
  }

  void onConnect(){
    _socket.onConnect();
  }
  void disconnect(){
    _socket.disconnect();
  }
  void onLeave(){
    _socket.onLeave();
  }
  void sendMessage(){
    _socket.sendMessage();
  }
  Stream<dynamic> onEvent(String event){
    return _socket.onEvent(event);
  }

}