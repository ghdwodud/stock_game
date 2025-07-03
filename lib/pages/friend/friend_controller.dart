import 'package:com.jyhong.stock_game/main.dart';
import 'package:com.jyhong.stock_game/pages/chat/chat/chat_page.dart';
import 'package:com.jyhong.stock_game/pages/chat/chat_room/chat_room_controller.dart';
import 'package:get/get.dart';
import '../../services/friend_service.dart'; // 경로는 실제 위치에 맞게 수정

class FriendsController extends GetxController {
  final FriendService _friendService = Get.find<FriendService>();

  final friends = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  final searchResults = <Map<String, dynamic>>[].obs;
  final isSearching = false.obs;

  final receivedRequests = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    logger.d('onReady');
    super.onReady();
    fetchReceivedRequests();
    fetchFriends();
  }

  Future<void> fetchFriends() async {
    isLoading.value = true;
    try {
      final data = await _friendService.getFriends();
      friends.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', '친구 목록을 불러오는 데 실패했습니다.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendFriendRequest(String uuid) async {
    try {
      await _friendService.sendFriendRequest(uuid);
      await fetchReceivedRequests();
      Get.snackbar('요청 완료', '친구 요청을 보냈습니다.');
    } catch (e) {
      Get.snackbar('Error', '친구 요청 실패: $e');
    }
  }

  // friends 리스트는 단방향이라 서버 제거 기능은 구현하지 않음 (API 없기 때문)
  void removeLocalFriend(String name) {
    friends.remove(name);
    Get.snackbar('Removed', '$name removed from local list');
  }

  Future<void> acceptRequest(String requestId) async {
    try {
      await _friendService.acceptFriendRequest(requestId);
      Get.snackbar('수락됨', '친구 요청을 수락했습니다.');
      await fetchFriends(); // 친구 목록 갱신
      await fetchReceivedRequests(); // 🔄 친구 요청 목록 갱신 ← 이게 빠졌었음
    } catch (e) {
      Get.snackbar('Error', '요청 수락 실패: $e');
    }
  }

  Future<void> rejectRequest(String requestId) async {
    try {
      await _friendService.rejectFriendRequest(requestId);
      Get.snackbar('거절됨', '친구 요청을 거절했습니다.');
      await fetchReceivedRequests(); // 🔄 요청 리스트도 갱신 필요
    } catch (e) {
      Get.snackbar('Error', '요청 거절 실패: $e');
    }
  }

  Future<void> searchFriends(String keyword) async {
    if (keyword.trim().isEmpty) {
      searchResults.clear();
      return;
    }

    isSearching.value = true;
    try {
      final results = await _friendService.searchUsers(keyword);
      searchResults.assignAll(results);
      print('🔍 검색 결과 (${results.length}개):');
      for (var user in results) {
        print('  - ${user['nickname']} (${user['uuid']})');
      }
    } catch (e) {
      Get.snackbar('Error', '유저 검색 실패: $e');
    } finally {
      isSearching.value = false;
    }
  }

  Future<void> fetchReceivedRequests() async {
    try {
      final data = await _friendService.getReceivedFriendRequests();
      print('📥 받은 요청 개수: ${data.length}');
      for (var item in data) {
        print('👤 요청자: ${item['nickname']} (${item['uuid']})');
      }
      receivedRequests.assignAll(data);
    } catch (e, st) {
      print('❌ 친구 요청 불러오기 실패: $e');
      print('📍 Stacktrace: $st');
      Get.snackbar('Error', '친구 요청 목록을 불러오는 데 실패했습니다.');
    }
  }

  Future<void> removeFriend(String uuid, String nickname) async {
    try {
      await _friendService.deleteFriend(uuid);
      Get.snackbar('삭제됨', '$nickname 님을 친구 목록에서 제거했습니다.');
      await fetchFriends(); // 최신화
    } catch (e) {
      Get.snackbar('Error', '친구 삭제 실패: $e');
    }
  }

  void handleChatWithFriend(Map<String, dynamic> friend) async {
    final chatRoomController = Get.find<ChatRoomController>();
    final myUuid = chatRoomController.myUuid;
    final selectedUuid = friend['uuid'];

    // 1. 기존 채팅방 찾기
    final existingRoom = chatRoomController.chatRooms.firstWhereOrNull(
      (room) => (room['members'] as List).any(
        (e) => e['user']['uuid'] == selectedUuid,
      ),
    );

    if (existingRoom != null) {
      final other = (existingRoom['members'] as List)
          .map((e) => e['user'])
          .firstWhere((user) => user['uuid'] != myUuid);

      Get.to(
        () => ChatPage(
          uuid: other['uuid'],
          nickname: other['nickname'],
          myUuid: myUuid,
          roomId: existingRoom['id'],
        ),
      );
    } else {
      // 2. 새 채팅방 생성
      final newRoom = await chatRoomController.createChatRoom(selectedUuid);
      if (newRoom != null) {
        final other = (newRoom['members'] as List)
            .map((e) => e['user'])
            .firstWhere((user) => user['uuid'] != myUuid);

        Get.to(
          () => ChatPage(
            uuid: other['uuid'],
            nickname: other['nickname'],
            myUuid: myUuid,
            roomId: newRoom['id'],
          ),
        );
      }
    }
  }
}
