import 'package:com.jyhong.stock_game/enum/friend_select_mode.dart';
import 'package:com.jyhong.stock_game/pages/chat/chat_room/chat_room_tile.dart';
import 'package:com.jyhong.stock_game/pages/widgets/friend_select_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../chat/chat_page.dart';
import 'chat_room_controller.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final controller = Get.put(ChatRoomController());

  @override
  void initState() {
    super.initState();
    controller.fetchChatRooms(); // 페이지 진입 시 목록 갱신
  }

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
              room: room,
              myUuid: controller.myUuid,
              onDelete: () => controller.deleteChatRoom(room['id']),
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
            final myUuid = controller.myUuid;

            // 1. 기존 채팅방 있는지 확인
            final existingRoom = controller.chatRooms.firstWhereOrNull(
              (room) => (room['members'] as List).any(
                (e) => e['user']['uuid'] == selectedUuid,
              ),
            );

            if (existingRoom != null) {
              final other = (existingRoom['members'] as List)
                  .map((e) => e['user'])
                  .firstWhere((user) => user['uuid'] != myUuid);

              Get.to(
                () => ChatPage(
                  uuid: other['uuid'],
                  nickname: other['nickname'],
                  myUuid: myUuid,
                  roomId: existingRoom['id'],
                ),
              );
            } else {
              // 2. 없으면 새로 생성
              final newRoom = await controller.createChatRoom(selectedUuid);
              if (newRoom != null) {
                final other = (newRoom['members'] as List)
                    .map((e) => e['user'])
                    .firstWhere((user) => user['uuid'] != myUuid);

                Get.to(
                  () => ChatPage(
                    uuid: other['uuid'],
                    nickname: other['nickname'],
                    myUuid: myUuid,
                    roomId: newRoom['id'],
                  ),
                );
              }
            }
          }
        },
        tooltip: '채팅방 만들기',
        child: const Icon(Icons.chat),
      ),
    );
  }
}
