import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'register_controller.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final controller = Get.put(RegisterController());

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
                "회원가입",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "간단한 정보를 입력해주세요",
                style: TextStyle(fontSize: 16, color: Colors.grey[500]),
              ),

              const Spacer(),

              // 이름
              TextField(
                decoration: const InputDecoration(labelText: '이름'),
                onChanged: (val) => controller.name.value = val,
              ),
              const SizedBox(height: 12),

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
              const SizedBox(height: 12),

              // 비밀번호 확인
              TextField(
                obscureText: true,
                decoration: const InputDecoration(labelText: '비밀번호 확인'),
                onChanged: (val) => controller.confirmPassword.value = val,
              ),
              const SizedBox(height: 24),

              // 회원가입 버튼
              Obx(
                () => ElevatedButton(
                  onPressed:
                      controller.isLoading.value ? null : controller.register,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child:
                      controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("회원가입"),
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
