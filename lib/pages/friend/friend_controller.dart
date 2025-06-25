import 'package:get/get.dart';
import '../../services/friend_service.dart'; // 경로는 실제 위치에 맞게 수정

class FriendsController extends GetxController {
  final FriendService _friendService = Get.find<FriendService>();

  final friends = <String>[].obs;
  final isLoading = false.obs;

  final searchResults = <Map<String, dynamic>>[].obs;
  final isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFriends();
  }

  Future<void> fetchFriends() async {
    isLoading.value = true;
    try {
      final data = await _friendService.getFriends();
      final friendNames = data.map((f) => f['nickname'] as String).toList();
      friends.assignAll(friendNames);
    } catch (e) {
      Get.snackbar('Error', '친구 목록을 불러오는 데 실패했습니다.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendFriendRequest(String uuid) async {
    try {
      await _friendService.sendFriendRequest(uuid);
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
      await fetchFriends();
    } catch (e) {
      Get.snackbar('Error', '요청 수락 실패: $e');
    }
  }

  Future<void> rejectRequest(String requestId) async {
    try {
      await _friendService.rejectFriendRequest(requestId);
      Get.snackbar('거절됨', '친구 요청을 거절했습니다.');
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
}
