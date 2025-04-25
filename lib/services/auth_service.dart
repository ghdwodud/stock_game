import 'package:get/get.dart';

class AuthService extends GetxService {
  final RxString _userUuid = ''.obs;
  final RxString _nickname = ''.obs;
  final RxString _jwt = ''.obs;

  String get userUuid => _userUuid.value;
  String get nickname => _nickname.value;
  String get jwt => _jwt.value;
  bool get isLoggedIn => _jwt.value.isNotEmpty;

  void setAuth({
    required String userUuid,
    required String nickname,
    required String token,
  }) {
    _userUuid.value = userUuid;
    _nickname.value = nickname;
    _jwt.value = token;
  }
}

