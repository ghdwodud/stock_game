import 'package:get/get.dart';

class AuthService extends GetxService {
  final RxInt _userId = 0.obs;
  final RxString _nickname = ''.obs;
  final RxString _jwt = ''.obs;

  int get currentUserId => _userId.value;
  String get nickname => _nickname.value;
  String get jwt => _jwt.value;
  bool get isLoggedIn => _jwt.value.isNotEmpty;

  void setAuth({required int userId, required String nickname, required String token}) {
    _userId.value = userId;
    _nickname.value = nickname;
    _jwt.value = token;
  }

  void logout() {
    _userId.value = 0;
    _nickname.value = '';
    _jwt.value = '';
  }
}
