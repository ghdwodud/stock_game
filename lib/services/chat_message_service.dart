import 'package:com.jyhong.stock_game/services/api_service.dart';

class ChatMessageService {
  final ApiService _api = ApiService();

  Future<List<Map<String, dynamic>>> fetchMessages(String roomId) async {
    final res = await _api.get('/chat/messages/$roomId');
    return List<Map<String, dynamic>>.from(res);
  }
}
