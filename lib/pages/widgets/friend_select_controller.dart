import 'package:get/get.dart';
import 'package:com.jyhong.stock_game/services/friend_service.dart';
import 'package:com.jyhong.stock_game/enum/friend_select_mode.dart';
import 'package:com.jyhong.stock_game/main.dart'; // logger

class FriendSelectController extends GetxController {
  final FriendService _friendService = Get.find<FriendService>();
  final FriendSelectMode mode;

  // 생성자에서 mode 받기
  FriendSelectController(this.mode);

  // 내 친구 전체 목록
  final friends = <Map<String, dynamic>>[].obs;

  // 내 친구 목록 내 검색 결과
  final filteredMyFriends = <Map<String, dynamic>>[].obs;

  // 전체 유저 검색 결과
  final searchResults = <Map<String, dynamic>>[].obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (mode == FriendSelectMode.myFriends) {
      fetchFriends();
    }
  }

  /// 내 친구 목록 불러오기
  Future<void> fetchFriends() async {
    try {
      isLoading.value = true;
      final res = await _friendService.getFriends();
      friends.assignAll(res);
      filteredMyFriends.assignAll(res);
      logger.i('👥 내 친구 ${res.length}명 로드됨');
    } catch (e, st) {
      logger.e('❌ 친구 목록 로딩 실패', error: e, stackTrace: st);
    } finally {
      isLoading.value = false;
    }
  }

  /// 전체 유저 검색
  Future<void> searchFriends(String keyword) async {
    try {
      isLoading.value = true;
      final res = await _friendService.searchUsers(keyword);
      searchResults.assignAll(res);
      logger.i('🔍 유저 검색 결과 ${res.length}건');
    } catch (e, st) {
      logger.e('❌ 유저 검색 실패', error: e, stackTrace: st);
    } finally {
      isLoading.value = false;
    }
  }

  /// 내 친구 목록 내에서 검색
  void searchFriendsInMyList(String keyword) {
    final filtered =
        friends.where((friend) {
          final nickname = (friend['nickname'] ?? '').toLowerCase();
          return nickname.contains(keyword.toLowerCase());
        }).toList();
    filteredMyFriends.assignAll(filtered);
    logger.i('🔍 친구 목록 내 검색 결과 ${filtered.length}건');
  }

  /// 친구 요청 보내기
  Future<void> sendFriendRequest(String uuid) async {
    try {
      await _friendService.sendFriendRequest(uuid);
      logger.i('✅ 친구 요청 전송됨: $uuid');
    } catch (e, st) {
      logger.e('❌ 친구 요청 실패', error: e, stackTrace: st);
    }
  }
}
