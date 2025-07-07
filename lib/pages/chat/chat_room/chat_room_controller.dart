import 'package:com.jyhong.stock_game/main.dart';
import 'package:com.jyhong.stock_game/services/chat_room_service.dart';
import 'package:com.jyhong.stock_game/services/chat_socket_service.dart';
import 'package:get/get.dart';
import 'package:com.jyhong.stock_game/services/auth_service.dart';

class ChatRoomController extends GetxController {
  final chatRooms = <Map<String, dynamic>>[].obs;
  final ChatRoomService _chatRoomService = Get.find<ChatRoomService>();
  final AuthService _auth = Get.find<AuthService>();
  String get myUuid => _auth.userUuid;

  @override
  void onInit() {
    super.onInit();
    fetchChatRooms();
  }

  Future<void> fetchChatRooms() async {
    try {
      final rooms = await _chatRoomService.fetchMyChatRooms(myUuid);
      logger.d('📥 가져온 채팅방 목록 (${rooms.length}개): $rooms');
      chatRooms.value = rooms;
    } catch (e) {
      logger.e('🚨 채팅방 목록 불러오기 실패', error: e);
    }
  }

  Future<Map<String, dynamic>?> createChatRoom(String friendUuid) async {
    try {
      final newRoom = await _chatRoomService.createRoomWith(friendUuid);
      chatRooms.add(newRoom);
      logger.d('🐛 createChatRoom newRoom:$newRoom');
      return newRoom;
    } catch (e) {
      Get.snackbar('오류', '채팅방 생성 실패: $e');
      return null;
    }
  }

  Future<void> deleteChatRoom(String roomId) async {
    try {
      await _chatRoomService.deleteRoom(roomId); // 서버에 삭제 요청

      final deletedRoom = chatRooms.firstWhere((room) => room['id'] == roomId);
      final members = List<Map<String, dynamic>>.from(deletedRoom['members']);
      final memberUuids =
          members.map((m) => m['user']['uuid'] as String).toList();
      final friendUuid = memberUuids.firstWhere((uuid) => uuid != myUuid);

      // 🔌 상대방에게 삭제 알림 전송
      Get.find<ChatSocketService>().emitDeletedRoom(friendUuid, roomId);

      // 🧹 로컬 목록에서 제거
      chatRooms.removeWhere((room) => room['id'] == roomId);

      Get.snackbar('삭제 완료', '채팅방이 삭제되었습니다.');
    } catch (e) {
      logger.e('❌ 채팅방 삭제 실패', error: e);
      Get.snackbar('오류', '채팅방 삭제 실패: $e');
    }
  }

  Future<void> updateRooms(List<Map<String, dynamic>> rooms) async {
    chatRooms.value = rooms;
  }
}
