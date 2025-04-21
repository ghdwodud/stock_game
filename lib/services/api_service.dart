import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // --dart-define=BASE_URL=... 으로 주입
  final String baseUrl = const String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:3000', // 개발 기본값
  );

  Future<dynamic> get(String endpoint) async {
    final res = await http.get(Uri.parse('$baseUrl$endpoint'));
    return _processResponse(res);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return _processResponse(res);
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
