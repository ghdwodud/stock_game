import 'dart:math' as console;
import 'package:com.jyhong.stock_game/main.dart';
import 'package:com.jyhong.stock_game/services/chat_socket_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  final RxString _userUuid = ''.obs;
  final RxString _nickname = ''.obs;
  final RxString _jwt = ''.obs;
  final RxString _refreshToken = ''.obs;
  final RxString _avatarUrl = ''.obs;

  SharedPreferences? _prefs;

  String get userUuid => _userUuid.value;
  String get nickname => _nickname.value;
  String get jwt => _jwt.value;
  String get refreshToken => _refreshToken.value;
  String get avatarUrl => _avatarUrl.value;
  bool get isLoggedIn => _jwt.value.isNotEmpty;

  set avatarUrl(String value) => _avatarUrl.value = value;

  static const _userUuidKey = 'userUuid';
  static const _nicknameKey = 'nickname';
  static const _jwtKey = 'accessToken';
  static const _refreshTokenKey = 'refreshToken';
  static const _avatarUrlKey = 'avatarUrl';

  Future<AuthService> init() async {
    _prefs = await SharedPreferences.getInstance();
    _userUuid.value = _prefs?.getString(_userUuidKey) ?? '';
    _nickname.value = _prefs?.getString(_nicknameKey) ?? '';
    _jwt.value = _prefs?.getString(_jwtKey) ?? '';
    _refreshToken.value = _prefs?.getString(_refreshTokenKey) ?? '';
    _avatarUrl.value = _prefs?.getString(_avatarUrlKey) ?? '';
    if (isLoggedIn) {
      // ✅ 자동 로그인 상태라면 소켓도 자동 연결
      final socketService = Get.find<ChatSocketService>();
      socketService.connect(_userUuid.value);
      logger.d('[AuthService] 자동 로그인: 소켓 연결됨 (uuid: ${_userUuid.value})');
    }
    return this;
  }

  Future<void> setAuth({
    required String userUuid,
    required String nickname,
    required String token,
    required String refreshToken,
    String? avatarUrl,
  }) async {
    await _prefs?.setString(_userUuidKey, userUuid);
    await _prefs?.setString(_nicknameKey, nickname);
    await _prefs?.setString(_jwtKey, token);
    await _prefs?.setString(_refreshTokenKey, refreshToken);
    if (avatarUrl != null) {
      await _prefs?.setString(_avatarUrlKey, avatarUrl);
      _avatarUrl.value = avatarUrl;
    }

    _userUuid.value = userUuid;
    _nickname.value = nickname;
    _jwt.value = token;
    _refreshToken.value = refreshToken;

    final socketService = Get.find<ChatSocketService>();
    socketService.connect(userUuid);
    logger.d('[AuthService] setAuth: 소켓 연결됨 (uuid: $userUuid)');
  }

  Future<void> clearAuth() async {
    await _prefs?.remove(_userUuidKey);
    await _prefs?.remove(_nicknameKey);
    await _prefs?.remove(_jwtKey);
    await _prefs?.remove(_refreshTokenKey);
    await _prefs?.remove(_avatarUrlKey);

    _userUuid.value = '';
    _nickname.value = '';
    _jwt.value = '';
    _refreshToken.value = '';
    _avatarUrl.value = '';

    final socketService = Get.find<ChatSocketService>();
    socketService.disconnect();
    logger.d('[AuthService] clearAuth: 소켓 연결 해제됨');
  }

  Future<void> logout() async {
    await clearAuth();
  }

  Future<void> updateAvatarUrl(String value) async {
    _avatarUrl.value = value;
    await _prefs?.setString(_avatarUrlKey, value);
  }
}
