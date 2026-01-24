import 'dart:async';

import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:test_us_app/services/socket/Isocket_io_client.dart';

class SocketIoClient implements ISocketClient {
  final logger = Logger();
  IO.Socket? _socket;
  final StreamController<dynamic> _streamController = StreamController<dynamic>.broadcast();


  @override
  void init(String host, String token) {
    if (_socket != null) return; // 이미 초기화되었다면 중복 생성 방지

    _socket = IO.io(host, IO.OptionBuilder()
        .setTransports(['websocket']) // 핵심: websocket 우선 사용
        .disableAutoConnect()        // 수동 연결 제어를 위해 false
        .build());
    logger.d('[SocketIO] init completed : $host');
    // 서버로부터의 이벤트를 Stream으로 변환 (Provider/Bloc에서 듣기 위함)
    _socket!.onAny((event, data) {
      _streamController.add({'event': event, 'data': data});
    });
    logger.d('[SocketIO] event listener created');
  }

  @override
  void onConnect() {
    _socket!.connect();
    logger.d('socket connected');
  }

  @override
  void disconnect() {
    _socket?.disconnect();
  }

  @override
  void onLeave() {
    _socket?.dispose();
  }

  @override
  void sendMessage() {
    _socket?.emit('chat_message', {'message': 'Hello, server!'});
  }

  @override
  Stream onEvent(String event) {
    return _streamController.stream.where((e) => e['event'] == event);
  }

}