import 'dart:async';

import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:test_us_app/domain/entities/message_entity.dart';
import 'package:test_us_app/services/socket/Isocket_io_client.dart';

import '../../data/models/message/message_model.dart';

class TReqMessageEntity {
  int? roomId;
  String? content;
  String? targetId;
  String? postId;
  TReqMessageEntity({this.roomId, this.content, this.targetId, this.postId});
}

class SocketIOClientImpl implements ISocketClient {
  final logger = Logger(level: Level.debug, printer: PrettyPrinter());
  IO.Socket? _socket;

  /// ✅ 반드시 broadcast
  /// 여러 Provider / UI / UseCase에서 동시에 listen 가능
  final StreamController<Map<String, dynamic>> _streamController =
  StreamController<Map<String, dynamic>>.broadcast();

  @override
  void init(String host, String token) {
    if (_socket != null) {
      _socket!.dispose();
      _socket = null;
    }

    _socket = IO.io(
      host,
      IO.OptionBuilder()
          .setTransports(['websocket']) // websocket 고정 (polling 방지)
          .setAuth({'token': token})    // auth token
          .disableAutoConnect()         // connect()를 수동으로 제어
          .build(),
    );

    logger.d("SOCKET URI: ${_socket!.io.uri}");
    logger.d('[SocketIO] init completed : $host');

    /// ✅ 모든 socket 이벤트를 Stream으로 흘려보냄
    /// 이 구조가 성립하려면 subscribeEvent와 구조가 정확히 일치해야 함
    _socket!.onAny((event, data) {
      logger.d('[SocketIO] onAny event=$event data=$data');

      _streamController.add({
        'event': event, // ex) chat_message
        'data': data,   // payload
      });
    });

    /// ❗ 에러 / 연결 해제 로그는 필수 (디버깅용)
    _socket!.onDisconnect((_) {
      logger.w('[SocketIO] disconnected');
    });

    _socket!.onError((err) {
      logger.e('[SocketIO] error: $err');
    });

    logger.d('[SocketIO] global event listener registered');
  }

  @override
  void connect() {
    if (_socket == null) {
      logger.e('[SocketIO] connect() called before init()');
      return;
    }

    if (_socket!.connected) {
      logger.d('[SocketIO] already connected');
      return;
    }

    logger.d('[SocketIO] connecting...');
    _socket!.connect();
  }

  @override
  void onConnect(Function(dynamic data) callback) {
    /// ✅ 실제 연결 완료 시점
    _socket!.onConnect((data) {
      logger.d('✅ socket connected');
      callback(data);
    });
  }

  @override
  bool connected() {
    return _socket?.connected ?? false;
  }

  @override
  void disconnect() {
    logger.d('[SocketIO] disconnect()');
    _socket?.disconnect();
  }

  @override
  void joinRoom(int roomId) {
    /// ❗ 반드시 connect 이후 호출
    logger.d('[SocketIO] join_room: $roomId');
    _socket?.emit('join_room', roomId);
  }
  @override
  void joinUser(String userId) {
    /// ❗ 반드시 connect 이후 호출
    logger.d('[SocketIO] join_user: $userId');
    _socket?.emit('join_user', userId);
  }

  @override
  void onLeave(int? roomId, String userId, String? targetUserId) {
    logger.d('[SocketIO] leave_room: $roomId');
    logger.d('[SocketIO] leave_user: $userId');
    logger.d('[SocketIO] leave_target_user: $targetUserId');
    if(roomId != null){
      _socket?.emit('leave room', roomId);
    }
    if(targetUserId != null){
      _socket?.emit('leave user', targetUserId);
    }
    _socket?.emit('leave user', userId);
  }

  @override
  void sendMessage(TReqMessageEntity message) {
    /// ❗ room join 이후에 보내야 수신 가능
    final payload = {
      'roomId': message.roomId,
      'content': message.content,
      'targetId': message.targetId,
      'postId': message.postId,
    };

    logger.d('[SocketIO] emit chat_message: $payload');
    _socket?.emit('chat_message', payload);
  }

  @override
  Stream<T> subscribeEvent<T>(
      String eventName,
      T Function(dynamic data) mapper,
      ) {
    logger.d('[SocketIO] subscribeEvent: $eventName');

    return _streamController.stream
        .where((event) {
      final match = event['event'] == eventName;

      /// 🔥 디버깅 핵심 로그
      logger.d(
        '[SocketIO] filter event=${event['event']} '
            'target=$eventName match=$match',
      );

      return match;
    })
        .map((event) {
      logger.d('[SocketIO] map event=$eventName data=${event['data']}');
      return mapper(event['data']);
    });
  }

  /// ✅ 반드시 dispose 제공 (앱 종료 시)
  void dispose() {
    logger.d('[SocketIO] dispose');
    _streamController.close();
    _socket?.dispose();
    _socket = null;
  }
}
