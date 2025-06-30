import 'package:get/get.dart';
import 'package:com.jyhong.stock_game/services/api_service.dart';
import 'package:com.jyhong.stock_game/services/auth_service.dart';

class ChatRoomController extends GetxController {
  final chatRooms = <Map<String, dynamic>>[].obs;
  final ApiService _api = ApiService();
  final AuthService _auth = Get.find<AuthService>();
  String get myUuid => _auth.userUuid;
  @override
  void onInit() {
    super.onInit();
    fetchChatRooms();
  }

  Future<void> fetchChatRooms() async {
    try {
      final uuid = _auth.userUuid;
      final res = await _api.get('/chat/rooms/$uuid');

      chatRooms.value = List<Map<String, dynamic>>.from(res);
    } catch (e) {
      print('🚨 채팅방 목록 불러오기 실패: $e');
    }
  }
}
