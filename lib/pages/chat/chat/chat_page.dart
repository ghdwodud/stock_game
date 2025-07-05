import 'package:com.jyhong.stock_game/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'chat_controller.dart';

class ChatPage extends StatelessWidget {
  final String uuid;
  final String nickname;
  final String myUuid;
  final String roomId;

  ChatPage({
    super.key,
    required this.uuid,
    required this.nickname,
    required this.myUuid,
    required this.roomId,
  }) {
    Get.put(
      ChatController(),
      tag: uuid,
    ).initChat(uuid, nickname, myUuid, roomId);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>(tag: uuid);
    final scrollController = ScrollController();

    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => const StockGameMainPage(initialIndex: 3));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(nickname),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.offAll(() => const StockGameMainPage(initialIndex: 3));
            },
          ),
        ),
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
                      child: Column(
                        crossAxisAlignment:
                            isMine
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children:
                                isMine
                                    ? [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 6,
                                        ),
                                        child: Text(
                                          DateFormat('a h:mm').format(
                                            message['timestamp'] as DateTime,
                                          ),
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade100,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          message['text'] ?? '',
                                          style: TextStyle(
                                            color: Colors.blue.shade900,
                                          ),
                                        ),
                                      ),
                                    ]
                                    : [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          message['text'] ?? '',
                                          style: const TextStyle(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 6),
                                        child: Text(
                                          DateFormat('a h:mm').format(
                                            message['timestamp'] as DateTime,
                                          ),
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ),
                                    ],
                          ),
                          const SizedBox(height: 6),
                        ],
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
                    width: 48,
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
      ),
    );
  }
}
