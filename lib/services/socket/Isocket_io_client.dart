
import 'package:test_us_app/domain/entities/message_entity.dart';
import 'package:test_us_app/services/socket/socket_io_client.dart';

abstract class ISocketClient {
  void init (String host, String token);
  void connect();
  void joinRoom(int roomId);
  void joinUser(String userId);
  bool connected () => true;
  void onConnect (Function(dynamic data) callback);
  void sendMessage (TReqMessageEntity message);
  void onLeave(int? roomId, String userId, String targetUserId);
  void disconnect();
  Stream<T> subscribeEvent<T>(String eventName, T Function(dynamic data) mapper);
}