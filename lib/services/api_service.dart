import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:get/get.dart';
import 'auth_service.dart'; // 실제 경로로 바꿔줘야 함

class ApiService {
  final String baseUrl = const String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  final Duration timeoutDuration = const Duration(seconds: 5);

  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse(
      '$baseUrl$endpoint',
    ).replace(queryParameters: queryParams);
    return _sendRequest(() => http.get(uri, headers: _buildHeaders()));
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    return _sendRequest(
      () => http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _buildHeaders(),
        body: jsonEncode(body),
      ),
    );
  }

  Map<String, String> _buildHeaders() {
    final authService = Get.find<AuthService>();
    final token = authService.jwt;

    return {
      'Content-Type': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> _sendRequest(Future<http.Response> Function() request) async {
    try {
      var res = await request().timeout(timeoutDuration);

      if (res.statusCode == 401) {
        print('⚠️ 401 Unauthorized: 토큰 만료 감지');

        final refreshSuccess = await _refreshToken();
        if (refreshSuccess) {
          print('✅ 토큰 재발급 성공, 요청 재시도');
          res = await request().timeout(timeoutDuration); // 👉 재요청
        } else {
          print('❌ 토큰 재발급 실패, 로그아웃 진행');

          final authService = Get.find<AuthService>();
          await authService.clearAuth(); // ✅ 데이터 초기화만
          Get.offAllNamed('/onboarding'); // ✅ 직접 페이지 이동
          throw Exception('Unauthorized');
        }
      }
      return _processResponse(res);
    } on TimeoutException {
      print('⏰ 요청 타임아웃');
      throw Exception('요청 시간이 초과되었습니다.');
    } catch (e) {
      print('❌ 요청 실패: $e');
      rethrow;
    }
  }

  Future<bool> _refreshToken() async {
    final authService = Get.find<AuthService>();
    final refreshToken = authService.refreshToken;

    if (refreshToken.isEmpty) {
      print('❌ 리프레시 토큰 없음');
      return false;
    }

    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/auth/refresh-token'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'refreshToken': refreshToken}),
          )
          .timeout(timeoutDuration);

      if (res.statusCode == 200) {
        // ✅ 서버도 200 OK로 고치자
        final data = jsonDecode(res.body);
        final newAccessToken = data['accessToken'] as String;
        final newRefreshToken = data['refreshToken'] as String;

        await authService.setAuth(
          userUuid: authService.userUuid,
          nickname: authService.nickname,
          token: newAccessToken,
          refreshToken: newRefreshToken,
        );

        print('✅ 새로운 access_token 저장 완료');
        return true;
      } else {
        print('❌ 리프레시 API 실패: ${res.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ 리프레시 API 호출 실패: $e');
      return false;
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

  Future<String> uploadAvatar(File file) async {
    final authService = Get.find<AuthService>();
    print('📤 업로드 시작');
    print('📦 파일 경로: ${file.path}');
    print('🔐 JWT 토큰: ${authService.jwt}');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/users/avatar'),
    );

    request.headers['Authorization'] = 'Bearer ${authService.jwt}';

    try {
      final multipartFile = await http.MultipartFile.fromPath(
        'avatar',
        file.path,
      );
      request.files.add(multipartFile);
      print('✅ 파일 첨부 완료: ${multipartFile.filename}');
    } catch (e) {
      print('❌ 파일 첨부 중 오류: $e');
      rethrow;
    }

    http.StreamedResponse response;
    try {
      response = await request.send();
      print('📡 서버 응답 상태 코드: ${response.statusCode}');
    } catch (e) {
      print('❌ 요청 전송 중 오류: $e');
      rethrow;
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = await response.stream.bytesToString();
      print('✅ 서버 응답 본문: $responseData');

      final json = jsonDecode(responseData);
      final uploadedUrl = json['avatarUrl'];

      // ✅ 업로드 성공 후 avatarUrl 저장
      await authService.updateAvatarUrl(uploadedUrl);

      return uploadedUrl;
    } else {
      final errorBody = await response.stream.bytesToString();
      print('❌ 업로드 실패: ${response.statusCode}, 응답: $errorBody');
      throw Exception('이미지 업로드 실패 (${response.statusCode})');
    }
  }

  Future<dynamic> delete(String endpoint) async {
    return _sendRequest(
      () =>
          http.delete(Uri.parse('$baseUrl$endpoint'), headers: _buildHeaders()),
    );
  }
}
