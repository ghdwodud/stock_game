import 'package:com.jyhong.stock_game/config/config.dart';
import 'package:com.jyhong.stock_game/main.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatSocketService {
  late IO.Socket socket;

  void connect(String myUuid) {
    logger.i('🟡 [Socket] 연결 시도 중... userId: $myUuid');

    socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({'userId': myUuid})
          .enableAutoConnect()
          .build(),
    );

    socket.onConnect((_) => logger.i('✅ [Socket] 연결됨'));
    socket.onConnectError((err) => logger.e('❌ [Socket] 연결 오류: $err'));
    socket.onError((err) => logger.e('❌ [Socket] 에러 발생: $err'));
    socket.onDisconnect((_) => logger.w('⚠️ [Socket] 연결 종료'));
  }

  void sendMessage(Map<String, dynamic> message) {
    logger.i('📤 [Socket] 메시지 전송: $message');
    socket.emit('send_message', message);
  }

  void onReceiveMessage(void Function(dynamic) handler) {
    logger.i('📡 [Socket] receive_message 리스너 등록');
    socket.off('receive_message'); // 중복 방지
    socket.on('receive_message', (data) {
      logger.i('📥 [Socket] 메시지 수신됨: $data');
      handler(data);
    });
  }

  void disconnect() {
    logger.w('🔌 [Socket] 소켓 연결 종료 요청됨');
    socket.dispose();
  }
}
