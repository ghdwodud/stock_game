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
      final GoogleSignIn _googleSignIn = GoogleSignIn();

      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print("🚨 사용자가 구글 로그인을 취소했습니다.");
        return;
      }

      // ✅ 인증 토큰 받아오기
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // ✅ Firebase 인증
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) throw Exception('Firebase 사용자 정보가 없습니다.');

      final idToken = await firebaseUser.getIdToken();
      if (idToken == null) throw Exception('idToken을 가져올 수 없습니다.');

      // ✅ 서버에 idToken 전달하여 JWT 발급 요청
      final response = await _api.post('/auth/google-login', {
        'idToken': idToken,
      });

      final jwt = response['token'];
      final user = response['user'];

      if (jwt == null ||
          user == null ||
          user['uuid'] == null ||
          user['name'] == null) {
        throw Exception('서버 응답이 올바르지 않습니다.');
      }

      // ✅ 앱 내 인증 상태 저장
      _authService.setAuth(
        userUuid: user['uuid'],
        nickname: user['name'],
        token: jwt,
      );

      // ✅ 로그인 성공 시 메인 페이지로 이동
      Get.offAllNamed('/main');
    } catch (e, st) {
      print('❌ 구글 로그인 실패: $e\n$st');
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
