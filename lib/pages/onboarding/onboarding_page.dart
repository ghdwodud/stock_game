import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'onboarding_controller.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({super.key});

  final controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),

            Text(
              "app_name".tr, // ✅ 앱 이름
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "welcome_subtitle".tr, // ✅ 서브 타이틀
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: controller.loginWithGoogle,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: Text("login_with_google".tr), // ✅ 구글 로그인
            ),
            const SizedBox(height: 16),

            // 나중에 애플 로그인 활성화할 때
            // SignInWithAppleButton(
            //   onPressed: () {
            //     // TODO: controller.loginWithApple()
            //   },
            //   style: SignInWithAppleButtonStyle.black,
            // ),
            // const SizedBox(height: 16),

            OutlinedButton(
              onPressed: controller.loginAsGuest,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: Text("try_as_guest".tr), // ✅ 게스트 체험
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
