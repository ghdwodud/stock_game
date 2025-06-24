import 'package:get/get.dart';
import '../services/api_service.dart';

class FriendService extends GetxService {
  final ApiService _api = Get.find<ApiService>();

  Future<List<dynamic>> getFriends() async {
    final res = await _api.get('/friends');
    return res as List<dynamic>;
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
    await _api.post('/friends/request/$requestId/accept', {});
  }

  Future<void> rejectFriendRequest(String requestId) async {
    await _api.post('/friends/request/$requestId/reject', {});
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    final res = await _api.get('/search', queryParams: {'q': query});
    return List<Map<String, dynamic>>.from(res);
  }
}
