import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserController extends GetxController {
  final uuid = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadOrCreateUUID();
  }

  void _loadOrCreateUUID() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUuid = prefs.getString('user_uuid');

    if (savedUuid == null) {
      final newUuid = const Uuid().v4(); // UUID 생성
      await prefs.setString('user_uuid', newUuid);
      uuid.value = newUuid;
    } else {
      uuid.value = savedUuid;
    }
  }
}
