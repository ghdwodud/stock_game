import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final messages = <String>[].obs; // 간단히 String으로 시작
  final inputController = TextEditingController();

  void sendMessage() {
    final text = inputController.text.trim();
    if (text.isNotEmpty) {
      messages.add(text);
      inputController.clear();
    }
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }
}
