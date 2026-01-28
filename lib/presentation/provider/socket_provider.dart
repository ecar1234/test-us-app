import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:test_us_app/data/models/message/message_model.dart';
import 'package:test_us_app/domain/use_cases/message_usecase.dart';
import 'package:test_us_app/presentation/provider/room_provider.dart';
import 'package:test_us_app/services/socket/Isocket_io_client.dart';
import 'package:test_us_app/services/socket/socket_io_client.dart';

import '../../domain/entities/message_entity.dart';
import '../../domain/entities/room_entity.dart';



class SocketProvider with ChangeNotifier {
  /// ✅ GetIt으로 주입된 SocketClient (Singleton)
  final ISocketClient _socket;
  SocketProvider(this._socket);

  StreamSubscription<MessageEntity>? _chatMessageSubscription;

  /// ✅ 메시지 상태 (UI에서 watch)
  List<MessageEntity>? _messages;

  List<MessageEntity>? get messages => _messages;

  /// ✅ RoomProvider는 외부에서 주입 (순환 참조 방지)
  RoomProvider? _roomProvider;

  void setRoomProvider(RoomProvider roomProvider) {
    _roomProvider = roomProvider;
  }

  void setMessages(List<MessageEntity> serverMessages) {
    _messages ??= [];
    _messages = serverMessages;
    notifyListeners();
  }

  /// ✅ 앱 시작 시 1회 호출
  /// - socket init
  /// - listener 등록 (connect 여부와 무관)
  void initializeSocket(String host, String token) {
    _socket.init(host, token);
    _registerListeners();
  }

  /// 🔥 핵심: 이벤트 리스너는 "한 번만" 등록
  /// connect 여부와 상관없이 미리 등록해두는 게 안전
  void _registerListeners() {
    if (_chatMessageSubscription != null) return;

    _chatMessageSubscription = _socket.subscribeEvent<MessageEntity>(
      'chat_message',
      (data) {
        final model = MessageModel.fromJson(data);
        return MessageEntity.toEntity(model);
      },
    ).listen(
      (event) {
        debugPrint('✅ chat_message received: ${event.id}');
        _messages = [event, ..._messages!];
        /// ❗ roomProvider는 nullable → 반드시 null 체크
        _roomProvider!.addRoom(event);
        notifyListeners();
      },
      onError: (e, s) {
        debugPrint('❌ socket stream error: $e');
        debugPrintStack(stackTrace: s);
      },
      onDone: () {
        debugPrint('⚠️ socket stream closed');
      },
    );
  }

  /// ✅ 실제 socket 연결 (UI initState / didChangeDependencies 에서 호출)
  void connect() {
    if (_socket.connected()) return;

    debugPrint('[SocketProvider] connect()');
    _socket.connect();
  }

  /// ✅ 방 입장 (connect + onConnect 이후 호출해야 함)
  void joinRoom(int roomId) {
    debugPrint('[SocketProvider] joinRoom: $roomId');
    _socket.joinRoom(roomId);
  }

  /// ✅ 메시지 전송
  /// 서버 emit → 다시 chat_message 로 내려오는 구조
  void sendMessage(TReqMessageEntity message) {
    debugPrint('[SocketProvider] sendMessage');
    _socket.sendMessage(message);
  }

  /// ✅ 방 나가기
  void leaveRoom(int roomId) {
    debugPrint('[SocketProvider] leaveRoom: $roomId');
    _socket.onLeave(roomId);
  }

  /// ✅ 소켓 완전 종료 (로그아웃 / 앱 종료 시)
  void disconnect() {
    debugPrint('[SocketProvider] disconnect');
    _socket.disconnect();
  }

  /// ❗ Provider dispose는 "listener만" 정리
  /// socket 자체는 App 생명주기에 맡김
  @override
  void dispose() {
    debugPrint('[SocketProvider] dispose');
    _chatMessageSubscription?.cancel();
    _chatMessageSubscription = null;
    super.dispose();
  }
}
