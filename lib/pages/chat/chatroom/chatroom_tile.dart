import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../chat/chat_page.dart';

class ChatRoomTile extends StatelessWidget {
  final Map<String, dynamic> room;
  final String myUuid;

  const ChatRoomTile({super.key, required this.room, required this.myUuid});

  @override
  Widget build(BuildContext context) {
    final other = (room['members'] as List)
        .map((e) => e['user'])
        .firstWhere((user) => user['uuid'] != myUuid);

    final nickname = other['nickname'] ?? '닉네임 없음';
    final avatarUrl = other['avatarUrl'];
    final lastMessage = room['lastMessage'] ?? '';

    return InkWell(
      onTap: () {
        Get.to(
          () =>
              ChatPage(uuid: other['uuid'], nickname: nickname, myUuid: myUuid),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
  }
}
