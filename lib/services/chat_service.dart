import 'package:com.jyhong.stock_game/config/config.dart';
import 'package:com.jyhong.stock_game/main.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  late IO.Socket socket;

  void connect(String myUuid) {
    logger.d('connect');
    socket = IO.io(
      baseUrl, // 변경됨!
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({'userId': myUuid})
          .enableAutoConnect()
          .build(),
    );

    socket.onConnect((_) => print('✅ 연결됨'));
    socket.onDisconnect((_) => print('❌ 연결 종료'));
  }

  void sendMessage(Map<String, dynamic> message) {
    logger.d('sendMessage message: ${message}');
    socket.emit('send_message', message);
  }

  void onReceiveMessage(void Function(dynamic) handler) {
    logger.d('onReceiveMessage handler: ${handler}');
    socket.on('receive_message', handler);
  }

  void disconnect() {
    socket.dispose();
  }
}
