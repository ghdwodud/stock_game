import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_controller.dart';

class ChatPage extends StatelessWidget {
  final String uuid;
  final String nickname;
  final String myUuid;

  ChatPage({
    super.key,
    required this.uuid,
    required this.nickname,
    required this.myUuid,
  }) {
    Get.put(ChatController(), tag: uuid).initChat(uuid, nickname, myUuid);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>(tag: uuid);
    final scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(title: Text(nickname)),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final msgLen = controller.messages.length;
              return ListView.builder(
                controller: scrollController,
                reverse: true,
                padding: const EdgeInsets.all(12),
                itemCount: msgLen,
                itemBuilder: (context, index) {
                  final reversedIndex = msgLen - 1 - index;
                  final message = controller.messages[reversedIndex];
                  final isMine = message['isMine'] == true;

                  return Align(
                    alignment:
                        isMine ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isMine
                                ? Colors.blue.shade100
                                : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        message['text'] ?? '',
                        style: TextStyle(
                          color: isMine ? Colors.blue.shade900 : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.inputController,
                    decoration: const InputDecoration(
                      hintText: '메시지를 입력하세요',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => controller.sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 48, // 또는 적절한 고정값
                  height: 48,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: controller.sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
