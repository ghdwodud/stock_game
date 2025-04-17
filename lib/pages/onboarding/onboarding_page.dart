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
              "📈 Stock Game",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "모의투자 게임을 시작해보세요!",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: controller.loginWithGoogle,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
              ),
              child: const Text("Google 계정으로 로그인"),
            ),
            const SizedBox(height: 16),

            SignInWithAppleButton(
              onPressed: () {
                // TODO: controller.loginWithApple()
              },
              style: SignInWithAppleButtonStyle.black,
            ),
            const SizedBox(height: 16),

            OutlinedButton(
              onPressed: controller.loginAsGuest,
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
              ),
              child: const Text("게스트로 체험하기"),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
