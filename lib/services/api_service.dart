import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ApiService {
  // --dart-define=BASE_URL=... 으로 주입
  final String baseUrl = const String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  final Duration timeoutDuration = Duration(seconds: 5); // ⏱ 타임아웃 설정

  Future<dynamic> get(String endpoint) async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl$endpoint'))
          .timeout(timeoutDuration);
      return _processResponse(res);
    } on TimeoutException {
      print('⏰ GET 요청 타임아웃');
      throw Exception('요청 시간이 초과되었습니다.');
    } catch (e) {
      print('❌ GET 요청 실패: $e');
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(timeoutDuration);
      return _processResponse(res);
    } on TimeoutException {
      print('⏰ POST 요청 타임아웃');
      throw Exception('요청 시간이 초과되었습니다.');
    } catch (e) {
      print('❌ POST 요청 실패: $e');
      rethrow;
    }
  }

  dynamic _processResponse(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body);
    } else {
      print('❌ API Error: ${res.statusCode} - ${res.body}');
      throw Exception('API Error: ${res.statusCode}');
    }
  }
}
