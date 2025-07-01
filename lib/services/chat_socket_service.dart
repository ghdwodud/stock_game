import 'package:com.jyhong.stock_game/config/config.dart';
import 'package:com.jyhong.stock_game/main.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatSocketService {
  late IO.Socket socket;

  void connect(String myUuid) {
    socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({'userId': myUuid})
          .enableAutoConnect()
          .build(),
    );

    socket.onConnect((_) => logger.i('✅ 연결됨'));
    socket.onDisconnect((_) => logger.w('❌ 연결 종료'));
  }

  void sendMessage(Map<String, dynamic> message) {
    socket.emit('send_message', message);
  }

  void onReceiveMessage(void Function(dynamic) handler) {
    socket.on('receive_message', handler);
  }

  void disconnect() {
    socket.dispose();
  }
}
