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
            final myUuid = controller.myUuid;

            final other = (room['members'] as List)
                .map((e) => e['user'])
                .firstWhere((user) => user['uuid'] != myUuid);

            final nickname = other['nickname'] ?? '닉네임 없음';
            final avatarUrl = other['avatarUrl'];
            final lastMessage = room['lastMessage'] ?? '';

            return InkWell(
              onTap: () {
                Get.to(
                  () => ChatPage(
                    uuid: other['uuid'],
                    nickname: nickname,
                    myUuid: myUuid,
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
                    CircleAvatar(
                      radius: 24,
                      backgroundImage:
                          avatarUrl != null ? NetworkImage(avatarUrl) : null,
                      child:
                          avatarUrl == null
                              ? Text(nickname.isNotEmpty ? nickname[0] : '?')
                              : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                nickname,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '오전 10:30', // TODO: updatedAt으로 변경 가능
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lastMessage,
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
            final newRoom = await controller.createChatRoom(selectedUuid);
            if (newRoom != null) {
              final myUuid = controller.myUuid;
              final other = (newRoom['members'] as List)
                  .map((e) => e['user'])
                  .firstWhere((user) => user['uuid'] != myUuid);

              Get.to(
                () => ChatPage(
                  uuid: other['uuid'],
                  nickname: other['nickname'],
                  myUuid: myUuid,
                ),
              );
            }
          }
        },
        child: const Icon(Icons.chat),
        tooltip: '채팅방 만들기',
      ),
    );
  }
}
