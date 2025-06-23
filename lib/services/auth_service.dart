import 'dart:math' as console;

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  final RxString _userUuid = ''.obs;
  final RxString _nickname = ''.obs;
  final RxString _jwt = ''.obs;
  final RxString _refreshToken = ''.obs;

  SharedPreferences? _prefs; // ✅ 캐싱

  String get userUuid => _userUuid.value;
  String get nickname => _nickname.value;
  String get jwt => _jwt.value;
  String get refreshToken => _refreshToken.value;
  bool get isLoggedIn => _jwt.value.isNotEmpty;

  static const _userUuidKey = 'userUuid';
  static const _nicknameKey = 'nickname';
  static const _jwtKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';

  Future<AuthService> init() async {
    _prefs = await SharedPreferences.getInstance(); // ✅ 한번만 가져옴
    _userUuid.value = _prefs?.getString(_userUuidKey) ?? '';
    _nickname.value = _prefs?.getString(_nicknameKey) ?? '';
    _jwt.value = _prefs?.getString(_jwtKey) ?? '';
    _refreshToken.value = _prefs?.getString(_refreshTokenKey) ?? '';
    return this;
  }

  Future<void> setAuth({
    required String userUuid,
    required String nickname,
    required String token,
    required String refreshToken,
  }) async {
    await _prefs?.setString(_userUuidKey, userUuid);
    await _prefs?.setString(_nicknameKey, nickname);
    await _prefs?.setString(_jwtKey, token);
    await _prefs?.setString(_refreshTokenKey, refreshToken);

    _userUuid.value = userUuid;
    _nickname.value = nickname;
    _jwt.value = token;
    _refreshToken.value = refreshToken;
  }

  Future<void> clearAuth() async {
    // ✅ 깔끔하게 이름 변경
    await _prefs?.remove(_userUuidKey);
    await _prefs?.remove(_nicknameKey);
    await _prefs?.remove(_jwtKey);
    await _prefs?.remove(_refreshTokenKey);

    _userUuid.value = '';
    _nickname.value = '';
    _jwt.value = '';
    _refreshToken.value = '';
  }

  Future<void> logout() async {
    await clearAuth();
  }
}
