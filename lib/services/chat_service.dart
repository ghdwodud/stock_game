import 'package:com.jyhong.stock_game/config/config.dart';
import 'package:com.jyhong.stock_game/services/api_service.dart';
import 'package:com.jyhong.stock_game/main.dart';
import 'package:com.jyhong.stock_game/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  late IO.Socket socket;
  final ApiService _api = Get.find<ApiService>();
  final AuthService _auth = Get.find<AuthService>();

  void connect(String myUuid) {
    logger.d('connect');
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
    logger.d('sendMessage message: $message');
    socket.emit('send_message', message);
  }

  void onReceiveMessage(void Function(dynamic) handler) {
    socket.on('receive_message', handler);
  }

  void disconnect() {
    socket.dispose();
  }

  Future<Map<String, dynamic>> createRoomWith(String friendUuid) async {
    final res = await _api.post('/chatroom', {
      'memberUuids': [_auth.userUuid, friendUuid],
    });
    return Map<String, dynamic>.from(res);
  }

  Future<List<Map<String, dynamic>>> fetchMyChatRooms() async {
    final uuid = _auth.userUuid;
    final res = await _api.get('/chatroom?userUuid=$uuid');
    return List<Map<String, dynamic>>.from(res);
  }
}
