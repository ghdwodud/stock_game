import 'package:com.jyhong.stock_game/enum/friend_select_mode.dart';
import 'package:com.jyhong.stock_game/pages/chat/chat_room/chat_room_tile.dart';
import 'package:com.jyhong.stock_game/pages/widgets/friend_select_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../chat/chat_page.dart';
import 'chat_room_controller.dart';

class ChatRoomPage extends StatelessWidget {
  final controller = Get.put(ChatRoomController());

  ChatRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('채팅')),
      body: Obx(() {
        return ListView.builder(
          itemCount: controller.chatRooms.length,
          itemBuilder: (context, index) {
            final room = controller.chatRooms[index];
            return ChatRoomTile(
              room: controller.chatRooms[index],
              myUuid: controller.myUuid,
              onDelete:
                  () => controller.deleteChatRoom(
                    controller.chatRooms[index]['id'],
                  ),
            );
          },
        );
      }),
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
