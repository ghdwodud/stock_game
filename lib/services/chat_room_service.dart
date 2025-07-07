import 'package:com.jyhong.stock_game/services/api_service.dart';
import 'package:com.jyhong.stock_game/services/auth_service.dart';
import 'package:com.jyhong.stock_game/services/chat_socket_service.dart';
import 'package:get/get.dart';

class ChatRoomService {
  final ApiService _api = Get.find<ApiService>();
  final AuthService _auth = Get.find<AuthService>();
  final ChatSocketService _socket = Get.find<ChatSocketService>();

  Future<Map<String, dynamic>> createRoomWith(String friendUuid) async {
    final res = await _api.post('/chatroom', {
      'memberUuids': [_auth.userUuid, friendUuid],
    });

    final room = Map<String, dynamic>.from(res);
    final roomId = room['id'] as String;

    // ✅ 상대방에게 소켓으로 new_room 이벤트 전송
    _socket.emitNewRoom(friendUuid, roomId);

    return room;
  }

  Future<List<Map<String, dynamic>>> fetchMyChatRooms(String myUuid) async {
    final uuid = _auth.userUuid;
    final res = await _api.get('/chatroom?userUuid=$uuid');
    return List<Map<String, dynamic>>.from(res);
  }

  Future<void> deleteRoom(String roomId) async {
    await _api.delete('/chatroom/$roomId');
  }
}
