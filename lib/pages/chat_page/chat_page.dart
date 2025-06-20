import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_controller.dart';

class ChatPage extends StatelessWidget {
  final controller = Get.put(ChatController());

  ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('chat'.tr)),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              reverse: true, // 최근 메시지가 아래로
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                final message = controller.messages.reversed.toList()[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(message),
                    ),
                  ),
                );
              },
            )),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.inputController,
                    decoration: InputDecoration(
                      hintText: 'type_a_message'.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: controller.sendMessage,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
