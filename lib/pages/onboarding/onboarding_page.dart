import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'onboarding_controller.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({super.key});

  final controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Text(
                "app_name".tr,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "welcome_subtitle".tr,
                style: TextStyle(fontSize: 16, color: Colors.grey[500]),
              ),
              const Spacer(),

              // 이메일
              TextField(
                decoration: const InputDecoration(labelText: '이메일'),
                onChanged: (val) => controller.email.value = val,
              ),
              const SizedBox(height: 12),

              // 비밀번호
              TextField(
                obscureText: true,
                decoration: const InputDecoration(labelText: '비밀번호'),
                onChanged: (val) => controller.password.value = val,
              ),
              const SizedBox(height: 24),

              // 로그인 버튼
              Obx(
                () => ElevatedButton(
                  onPressed:
                      controller.isLoading.value
                          ? null
                          : controller.loginWithEmailPassword,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child:
                      controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("로그인"),
                ),
              ),
              const SizedBox(height: 12),

              // 🔻 회원가입 버튼 추가
              TextButton(
                onPressed: controller.goToRegisterPage,
                child: const Text("계정이 없으신가요? 회원가입"),
              ),
              const SizedBox(height: 24),

              // Google 로그인
              // ElevatedButton.icon(
              //   onPressed: controller.loginWithGoogle,
              //   icon: const Icon(Icons.login),
              //   label: const Text("Google로 로그인"),
              //   style: ElevatedButton.styleFrom(
              //     minimumSize: const Size.fromHeight(48),
              //     backgroundColor: Colors.white,
              //     foregroundColor: Colors.black,
              //   ),
              // ),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: IconButton(
                  onPressed: controller.loginWithGoogle,
                  icon: Image.asset(
                    'assets/images/google_icon.png',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
