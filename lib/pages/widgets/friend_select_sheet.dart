import 'package:com.jyhong.stock_game/pages/widgets/friend_select_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:com.jyhong.stock_game/enum/friend_select_mode.dart';
import 'package:com.jyhong.stock_game/widgets/user_avatar.dart';

class FriendSelectSheet extends StatelessWidget {
  final FriendSelectMode mode;
  FriendSelectSheet({super.key, required this.mode});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FriendSelectController(mode));
    final isAllUserMode = mode == FriendSelectMode.allUsers;

    return Padding(
      padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(20)),
      child: Container(
        constraints: BoxConstraints(
          minHeight: 200,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: '닉네임 검색',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                if (isAllUserMode) {
                  controller.searchFriends(value);
                } else {
                  controller.searchFriendsInMyList(value);
                }
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                final isLoading = controller.isLoading.value;
                final list =
                    isAllUserMode
                        ? controller.searchResults
                        : controller.filteredMyFriends;

                if (isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (list.isEmpty) {
                  return const Center(child: Text('검색 결과 없음'));
                }

                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, index) {
                    final user = list[index];
                    final nickname = user['nickname'] ?? '이름 없음';
                    final uuid = user['uuid'];
                    final avatarUrl = user['avatarUrl'];

                    return ListTile(
                      leading: UserAvatar(avatarUrl: avatarUrl, radius: 20),
                      title: Text(
                        nickname,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing:
                          isAllUserMode
                              ? TextButton(
                                onPressed: () {
                                  controller.sendFriendRequest(uuid);
                                  Navigator.pop(context);
                                },
                                child: const Text('추가'),
                              )
                              : IconButton(
                                icon: const Icon(
                                  Icons.chat_bubble_outline,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                    uuid,
                                  ); // 채팅방 만들기용 UUID 반환
                                },
                              ),
                      onTap: () => Navigator.pop(context, uuid),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
