import 'package:com.jyhong.stock_game/main.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class FriendService extends GetxService {
  final ApiService _api = Get.find<ApiService>();

  Future<List<Map<String, dynamic>>> getFriends() async {
    final res = await _api.get('/friends');
    return List<Map<String, dynamic>>.from(res);
  }

  Future<List<dynamic>> getIncomingRequests() async {
    final res = await _api.get('/friends/requests/incoming');
    return res as List<dynamic>;
  }

  Future<List<dynamic>> getOutgoingRequests() async {
    final res = await _api.get('/friends/requests/outgoing');
    return res as List<dynamic>;
  }

  Future<void> sendFriendRequest(String uuid) async {
    await _api.post('/friends/request/$uuid', {});
  }

  Future<void> acceptFriendRequest(String requestId) async {
    print('acceptFriendRequest requestId:${requestId}');
    await _api.post('/friends/request/$requestId/accept', {});
  }

  Future<void> rejectFriendRequest(String requestId) async {
    await _api.post('/friends/request/$requestId/reject', {});
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    final res = await _api.get('/search', queryParams: {'q': query});
    return List<Map<String, dynamic>>.from(res);
  }

  Future<List<Map<String, dynamic>>> getReceivedFriendRequests() async {
    final data = await _api.get('/friends/requests/incoming');
    logger.i('📦 받은 데이터: $data');
    try {
      final parsed =
          (data as List)
              .map(
                (item) => {
                  'requestId': item['id'],
                  'uuid': item['sender']['uuid'],
                  'nickname': item['sender']['nickname'],
                  'avatarUrl': item['sender']['avatarUrl'],
                },
              )
              .toList();

      return parsed;
    } catch (e, st) {
      logger.e('❌ 파싱 실패', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<void> deleteFriend(String uuid) async {
    await _api.delete('/friends/$uuid');
  }
}
