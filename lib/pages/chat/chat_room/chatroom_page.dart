import 'package:com.jyhong.stock_game/enum/friend_select_mode.dart';
import 'package:com.jyhong.stock_game/pages/widgets/friend_select_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../chat/chat_page.dart';
import 'chatroom_controller.dart';

class ChatRoomPage extends StatelessWidget {
  final controller = Get.put(ChatRoomController());

  ChatRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('채팅')),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.chatRooms.length,
          itemBuilder: (context, index) {
            final room = controller.chatRooms[index];
            return InkWell(
              onTap: () {
                Get.to(
                  () => ChatPage(
                    uuid: room['uuid'],
                    nickname: room['nickname'],
                    myUuid: controller.myUuid,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(radius: 24, child: Text(room['nickname'][0])),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                room['nickname'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '오전 10:30',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            room['lastMessage'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final selectedUuid = await showModalBottomSheet<String>(
            context: context,
            isScrollControlled: true,
            builder: (_) => FriendSelectSheet(mode: FriendSelectMode.myFriends),
          );

          if (selectedUuid != null) {
            print('✅ 선택된 친구 uuid: $selectedUuid');
            // TODO: 채팅방 생성 로직 실행
          }
        },
        child: const Icon(Icons.chat),
        tooltip: '채팅방 만들기',
      ),
    );
  }
}
