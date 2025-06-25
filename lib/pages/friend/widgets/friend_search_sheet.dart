import 'package:com.jyhong.stock_game/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:com.jyhong.stock_game/pages/friend/friend_controller.dart';

class FriendSearchSheet extends StatefulWidget {
  @override
  _FriendSearchSheetState createState() => _FriendSearchSheetState();
}

class _FriendSearchSheetState extends State<FriendSearchSheet> {
  final FriendsController controller = Get.find();
  final TextEditingController searchController = TextEditingController();

  void _onSearchChanged(String value) {
    controller.searchFriends(value); // 닉네임 검색 API 호출
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(20)),
      child: Container(
        constraints: BoxConstraints(
          minHeight: 200, // 최소 높이
          maxHeight: MediaQuery.of(context).size.height * 0.6, // 최대 높이
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
              onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 20),
            Obx(() {
              final results = controller.searchResults;
              if (results.isEmpty) {
                return const Expanded(child: Center(child: Text("검색 결과 없음")));
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (_, index) {
                    final user = results[index];
                    final avatarUrl = user['avatarUrl'];

                    return ListTile(
                      leading: UserAvatar(avatarUrl: avatarUrl, radius: 20),
                      title: Text(user['nickname'] ?? '닉네임 없음'),
                      trailing: TextButton(
                        child: const Text('추가'),
                        onPressed: () {
                          controller.sendFriendRequest(user['uuid']);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
