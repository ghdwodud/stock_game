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
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 24,
        ), // ✅ 통일
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
                const SizedBox(height: 12), // ✅ 더 자연스러운 여백
                ...controller.receivedRequests.map(
                  (user) => Padding(
                    padding: const EdgeInsets.only(bottom: 12), // ✅ 카드 간 여백
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          child: Text(
                            user['nickname'].toString().isNotEmpty
                                ? user['nickname'][0]
                                : '?',
                          ),
                        ),
                        title: Text(user['nickname']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              onPressed:
                                  () => controller.acceptRequest(
                                    user['requestId'],
                                  ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed:
                                  () => controller.rejectRequest(
                                    user['requestId'],
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(thickness: 1, height: 20),
              ],

              const Text(
                '친구 목록',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12), // ✅ 더 자연스러운 여백
              // 친구 목록 리스트
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8), // ✅ 리스트 여백 추가
                  itemCount: controller.friends.length,
                  itemBuilder: (context, index) {
                    final friend = controller.friends[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12), // ✅ 카드 간 간격
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                child: Text((friend['nickname'] ?? '?')[0]),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  friend['nickname'],
                                  style: const TextStyle(fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.chat_bubble_outline,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  print('💬 ${friend['nickname']}에게 메시지 보내기');
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  Get.defaultDialog(
                                    title: "친구 삭제",
                                    middleText:
                                        "${friend['nickname']}님을 친구 목록에서 삭제하시겠습니까?",
                                    textCancel: "취소",
                                    textConfirm: "삭제",
                                    confirmTextColor: Colors.white,
                                    onConfirm: () {
                                      controller.removeFriend(
                                        friend['uuid'],
                                        friend['nickname'],
                                      );
                                      Get.back();
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
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
