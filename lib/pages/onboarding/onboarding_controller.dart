import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class OnboardingController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginWithGoogle() async {
    print('loginWithGoogle');
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // 사용자가 취소함

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      _onLoginSuccess();
    } catch (e) {
      Get.snackbar("로그인 실패", e.toString());
      print('loginWithGoogle error:${e.toString()}');
    }
  }

  Future<void> loginAsGuest() async {
    try {
      //await _auth.signInAnonymously();
      _onLoginSuccess();
    } catch (e) {
      Get.snackbar("게스트 로그인 실패", e.toString());
    }
  }

  void _onLoginSuccess() {
    final user = _auth.currentUser;
    print("로그인 성공: ${user?.uid}");
    Get.offAllNamed('/main'); // 메인 페이지로 이동
  }
}
