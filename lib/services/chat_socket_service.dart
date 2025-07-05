import 'package:com.jyhong.stock_game/config/config.dart';
import 'package:com.jyhong.stock_game/main.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatSocketService {
  late IO.Socket socket;
  bool _isConnected = false; // ✅ 중복 연결 방지 플래그

  /// 소켓 연결 시도
  void connect(String myUuid) {
    if (_isConnected) {
      logger.w('⚠️ [Socket] 이미 연결되어 있음, 재연결 생략 (userId: $myUuid)');
      return;
    }

    logger.i('🟡 [Socket] 연결 시도 중... userId: $myUuid');

    socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket']) // 웹소켓만 사용
          .setQuery({'userId': myUuid}) // 서버에 userId 전달
          .enableAutoConnect() // 자동 연결
          .build(),
    );

    socket.onConnect((_) {
      _isConnected = true;
      logger.i('✅ [Socket] 연결됨');
    });

    socket.onConnectError((err) {
      logger.e('❌ [Socket] 연결 오류: $err');
    });

    socket.onError((err) {
      logger.e('❌ [Socket] 에러 발생: $err');
    });

    socket.onDisconnect((_) {
      _isConnected = false;
      logger.w('⚠️ [Socket] 연결 종료');
    });
  }

  /// 메시지 전송
  void sendMessage(Map<String, dynamic> message) {
    if (!_isConnected) {
      logger.w('❌ [Socket] 연결되지 않음 → 메시지 전송 취소');
      return;
    }
    logger.i('📤 [Socket] 메시지 전송: $message');
    socket.emit('send_message', message);
  }

  /// 메시지 수신 핸들러 등록
  void onReceiveMessage(void Function(dynamic) handler) {
    logger.i('📡 [Socket] receive_message 리스너 등록');
    socket.off('receive_message'); // 중복 리스너 제거
    socket.on('receive_message', (data) {
      logger.i('📥 [Socket] 메시지 수신됨: $data');
      handler(data);
    });
  }

  /// 연결 해제
  void disconnect() {
    if (!_isConnected) {
      logger.w('🟤 [Socket] 연결된 상태가 아님 → disconnect 무시');
      return;
    }

    logger.w('🔌 [Socket] 소켓 연결 종료 요청됨');
    _isConnected = false;
    socket.dispose(); // 연결 종료
  }

  void joinRoom(String roomId) {
    if (socket == null) return;
    logger.i('📥 [Socket] 방 참가 요청: $roomId');
    socket!.emit('join', {'roomId': roomId});
  }
}
