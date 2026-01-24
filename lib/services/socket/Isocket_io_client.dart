
abstract class ISocketClient {
  void init (String host, String token);
  void onConnect ();
  void sendMessage ();
  void onLeave();
  void disconnect();
  Stream<dynamic> onEvent(String event);
}