import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import '../chat/chat_page.dart';

class ChatRoomTile extends StatelessWidget {
  final Map<String, dynamic> room;
  final String myUuid;
  final void Function()? onDelete;

  const ChatRoomTile({
    super.key,
    required this.room,
    required this.myUuid,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final other = (room['members'] as List)
        .map((e) => e['user'])
        .firstWhere((user) => user['uuid'] != myUuid);

    final nickname = other['nickname'] ?? '닉네임 없음';
    final avatarUrl = other['avatarUrl'];
    final lastMessage = room['lastMessage'] ?? '';

    return Slidable(
      key: Key(room['id'].toString()),
      endActionPane: ActionPane(
        motion: const DrawerMotion(), // 스르륵 나오는 애니메이션
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) async {
              final confirmed = await Get.dialog(
                AlertDialog(
                  title: const Text('채팅방 삭제'),
                  content: Text('$nickname 님과의 채팅방을 삭제하시겠습니까?'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(result: false),
                      child: const Text('취소'),
                    ),
                    TextButton(
                      onPressed: () => Get.back(result: true),
                      child: const Text('삭제'),
                    ),
                  ],
                ),
              );

              if (confirmed == true && onDelete != null) {
                onDelete!();
              }
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: '삭제',
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Get.to(
            () => ChatPage(
              uuid: other['uuid'],
              nickname: nickname,
              myUuid: myUuid,
              roomId: room['id'], // ← 이거 추가
            ),
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
      ),
    );
  }
}
