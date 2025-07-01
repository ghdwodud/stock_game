import 'package:com.jyhong.stock_game/services/api_service.dart';
import 'package:com.jyhong.stock_game/services/auth_service.dart';
import 'package:get/get.dart';

class ChatRoomService {
  final ApiService _api = Get.find<ApiService>();
  final AuthService _auth = Get.find<AuthService>();

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

  Future<void> deleteRoom(String roomId) async {
    await _api.delete('/chatroom/$roomId');
  }
}
