import 'package:com.jyhong.stock_game/common/widgets/common_app_bar.dart';
import 'package:com.jyhong.stock_game/pages/friend/friend_controller.dart';
import 'package:com.jyhong.stock_game/pages/friend/widgets/friend_search_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendsPage extends StatelessWidget {
  FriendsPage({super.key});

  final FriendsController controller = Get.put(FriendsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'friends'.tr),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'friends',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_add),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => FriendSearchSheet(),
                      );
                    },
                  ),
                ],
              ),
              const Divider(thickness: 1, height: 20),

              if (controller.receivedRequests.isNotEmpty) ...[
                const Text(
                  '받은 친구 요청',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...controller.receivedRequests.map(
                  (user) => ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        (user['nickname'] is String &&
                                user['nickname'].toString().isNotEmpty)
                            ? user['nickname'].toString()[0]
                            : '?',
                      ),
                    ),
                    title: Text(user['nickname']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed:
                              () => controller.acceptRequest(user['requestId']),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed:
                              () => controller.rejectRequest(user['requestId']),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(thickness: 1, height: 20),
              ],

              // 친구 리스트
              const Text(
                '친구 목록',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.friends.length,
                  itemBuilder: (context, index) {
                    final friend =
                        controller.friends[index]; // 이제 String이 아니라 Map이어야 함
                    return ListTile(
                      title: Text(friend['nickname']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed:
                            () => controller.removeFriend(
                              friend['uuid'],
                              friend['nickname'],
                            ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
