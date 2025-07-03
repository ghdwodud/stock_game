import 'package:com.jyhong.stock_game/main.dart';
import 'package:com.jyhong.stock_game/services/chat_message_service.dart';
import 'package:com.jyhong.stock_game/services/chat_socket_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final messages = <Map<String, dynamic>>[].obs;
  final inputController = TextEditingController();

  late String chatPartnerUuid;
  late String chatPartnerNickname;
  late String myUuid;
  late String roomId;

  final ChatSocketService _chatSocketService = ChatSocketService();
  final ChatMessageService _chatMessageService = ChatMessageService();

  void initChat(
    String partnerUuid,
    String partnerNickname,
    String myId,
    String roomId,
  ) async {
    chatPartnerUuid = partnerUuid;
    chatPartnerNickname = partnerNickname;
    myUuid = myId;
    this.roomId = roomId;

    _chatSocketService.connect(myUuid);

    // ✅ 기존 메시지 불러오기 (REST API)
    try {
      final history = await _chatMessageService.fetchMessages(roomId);
      messages.assignAll(
        history.map(
          (m) => {
            'text': m['text'],
            'isMine': m['senderId'] == myUuid,
            'timestamp': DateTime.parse(m['createdAt']),
          },
        ),
      );
    } catch (e) {
      debugPrint('❌ 메시지 불러오기 실패: $e');
    }

    _chatSocketService.onReceiveMessage((data) {
      print('✅ 소켓 메시지 도착: $data');
      final isMine = data['senderId'] == myUuid;
      messages.add({
        'text': data['text'],
        'isMine': isMine,
        'timestamp': DateTime.now(),
      });
    });
  }

  void sendMessage() {
    final text = inputController.text.trim();
    if (text.isEmpty) return;

    final msg = {'senderId': myUuid, 'roomId': roomId, 'text': text};

    _chatSocketService.sendMessage(msg);
    inputController.clear();
  }

  @override
  void onClose() {
    inputController.dispose();
    _chatSocketService.disconnect();
    super.onClose();
  }
}
