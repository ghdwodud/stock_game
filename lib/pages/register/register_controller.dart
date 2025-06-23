import 'package:com.jyhong.stock_game/services/api_service.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var isLoading = false.obs;

  void register() async {
    if (password.value != confirmPassword.value) {
      Get.snackbar('오류', '비밀번호가 일치하지 않습니다');
      return;
    }

    isLoading.value = true;

    try {
      print(
        '📌 RegisterController => name: ${name.value}, email: ${email.value}, password: ${password.value}',
      );

      await ApiService().post('/auth/register', {
        'name': name.value,
        'email': email.value,
        'password': password.value,
      });
      Get.snackbar('회원가입 성공', '이제 로그인하세요');
      Get.offAllNamed('/onboarding');
    } catch (e) {
      Get.snackbar('회원가입 실패', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
