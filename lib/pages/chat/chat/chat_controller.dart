import 'package:com.jyhong.stock_game/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final messages = <Map<String, dynamic>>[].obs;
  final inputController = TextEditingController();

  late String chatPartnerUuid;
  late String chatPartnerNickname;
  late String myUuid;
  final ChatService _chatService = ChatService();
  late String roomId;

  void initChat(
    String partnerUuid,
    String partnerNickname,
    String myId,
    String chatRoomId,
  ) {
    chatPartnerUuid = partnerUuid;
    chatPartnerNickname = partnerNickname;
    myUuid = myId;
    roomId = chatRoomId;

    _chatService.connect(myUuid);
    _chatService.onReceiveMessage((data) {
      final isMine = data['senderId'] == myUuid;

      messages.add({
        'text': data['text'],
        'isMine': isMine,
        'timestamp': DateTime.now(),
      });
    });

    messages.add({
      'text': '$chatPartnerNickname 님과의 대화를 시작합니다.',
      'isMine': false,
      'timestamp': DateTime.now(),
    });
  }

  void sendMessage() {
    final text = inputController.text.trim();
    if (text.isEmpty) return;

    final msg = {'senderId': myUuid, 'roomId': roomId, 'text': text};

    _chatService.sendMessage(msg);
    inputController.clear();
  }

  @override
  void onClose() {
    inputController.dispose();
    _chatService.disconnect();
    super.onClose();
  }
}
