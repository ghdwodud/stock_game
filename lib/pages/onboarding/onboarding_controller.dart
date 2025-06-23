import 'package:com.jyhong.stock_game/services/api_service.dart';
import 'package:com.jyhong.stock_game/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class OnboardingController extends GetxController {
  final ApiService _api = ApiService();
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isLoading = false.obs;

  // 폼 입력값 (아이디/비밀번호)
  final RxString email = ''.obs;
  final RxString password = ''.obs;

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print("🚨 사용자가 구글 로그인을 취소했습니다.");
        return;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) throw Exception('Firebase 사용자 정보가 없습니다.');

      final idToken = await firebaseUser.getIdToken();
      if (idToken == null) throw Exception('idToken을 가져올 수 없습니다.');

      final response = await _api.post('/auth/google-login', {
        'idToken': idToken,
      });

      final jwt = response['token'];
      final refreshToken = response['refreshToken'];
      final user = response['user'];

      if (jwt == null || refreshToken == null || user == null) {
        throw Exception('서버 응답이 올바르지 않습니다.');
      }

      await _authService.setAuth(
        userUuid: user['uuid'],
        nickname: user['name'],
        token: jwt,
        refreshToken: refreshToken,
      );

      Get.offAllNamed('/main');
    } catch (e, st) {
      print('❌ 구글 로그인 실패: $e\n$st');
      Get.snackbar("로그인 실패", e.toString());
    }
  }

  Future<void> loginWithEmailPassword() async {
    try {
      isLoading.value = true;

      final response = await _api.post('/auth/login', {
        'email': email.value,
        'password': password.value,
      });

      final jwt = response['token'];
      final refreshToken = response['refreshToken'];
      final user = response['user'];

      if (jwt == null || refreshToken == null || user == null) {
        throw Exception('서버 응답이 올바르지 않습니다.');
      }

      await _authService.setAuth(
        userUuid: user['uuid'],
        nickname: user['name'],
        token: jwt,
        refreshToken: refreshToken,
      );

      Get.offAllNamed('/main');
    } catch (e) {
      print('❌ 이메일 로그인 실패: $e');
      Get.snackbar("로그인 실패", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> goToRegisterPage() async {
    Get.toNamed('/register');
  }
}
