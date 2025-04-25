import 'package:com.jyhong.stock_game/services/api_service.dart';
import 'package:com.jyhong.stock_game/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class OnboardingController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ApiService _api = ApiService();
  final AuthService _authService = Get.find<AuthService>(); // ✅ 추가

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final idToken = await userCredential.user?.getIdToken();

      if (idToken == null) throw Exception('idToken을 가져올 수 없습니다.');

      final response = await _api.post('/auth/google-login', {
        'idToken': idToken,
      });

      final jwt = response['token'];
      final user = response['user'];

      // ✅ 상태 저장
      _authService.setAuth(
        userUuid: user['uuid'],
        nickname: user['nickname'],
        token: jwt,
      );

      Get.offAllNamed('/main');
    } catch (e) {
      print('❌ 구글 로그인 실패: $e');
      Get.snackbar("로그인 실패", e.toString());
    }
  }

  Future<void> loginAsGuest() async {
    try {
      final response = await _api.post('/auth/guest-login', {});
      print('✅ 서버 응답: $response');

      final jwt = response['token'];
      final user = response['user'];

      if (jwt == null || user == null) {
        throw Exception('서버 응답이 올바르지 않습니다. token 또는 user가 null입니다.');
      }

      _authService.setAuth(
        userUuid: user['uuid'],
        nickname: user['nickname'],
        token: jwt,
      );
      Get.offAllNamed('/main');
    } catch (e) {
      print('❌ 게스트 로그인 실패: $e');
      Get.snackbar("게스트 로그인 실패", e.toString());
    }
  }

}
