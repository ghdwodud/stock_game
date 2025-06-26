import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final inputController = TextEditingController();

  late String chatPartnerUuid;
  late String chatPartnerNickname;

  // ChatPage 진입 시 초기화
  void initChat(String uuid, String nickname) {
    chatPartnerUuid = uuid;
    chatPartnerNickname = nickname;

    // TODO: 서버에서 이전 메시지 불러오기 로직 추가 예정
    // 예시로 더미 메시지 하나 추가
    if (messages.isEmpty) {
      messages.add({
        'text': '$nickname 님과의 대화를 시작합니다.',
        'isMine': false,
        'timestamp': DateTime.now(),
      });
    }
  }

  void sendMessage() {
    final text = inputController.text.trim();
    if (text.isEmpty) return;

    messages.add({'text': text, 'isMine': true, 'timestamp': DateTime.now()});

    inputController.clear();

    // 응답 시뮬레이션 (테스트용)
    Future.delayed(const Duration(milliseconds: 400), () {
      messages.add({
        'text': '$chatPartnerNickname의 응답: $text',
        'isMine': false,
        'timestamp': DateTime.now(),
      });
    });
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }
}
