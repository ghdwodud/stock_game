import 'package:com.jyhong.stock_game/common/widgets/common_app_bar.dart';
import 'package:com.jyhong.stock_game/enum/friend_select_mode.dart';
import 'package:com.jyhong.stock_game/pages/friend/friend_controller.dart'
    show FriendsController;
import 'package:com.jyhong.stock_game/pages/friend/widgets/friend_card.dart';
import 'package:com.jyhong.stock_game/pages/friend/widgets/friend_section.dart';
import 'package:com.jyhong.stock_game/pages/widgets/friend_select_sheet.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 제목 + 추가 버튼
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
                        builder:
                            (_) => FriendSelectSheet(
                              mode: FriendSelectMode.allUsers,
                            ),
                      );
                    },
                  ),
                ],
              ),
              const Divider(thickness: 1, height: 20),

              // 받은 요청
              FriendSection(
                title: '받은 친구 요청',
                users: controller.receivedRequests,
                actionBuilder:
                    (user) => [
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

              // 친구 목록
              const Text(
                '친구 목록',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: controller.friends.length,
                  itemBuilder: (context, index) {
                    final friend = controller.friends[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: FriendCard(
                        user: friend,
                        actions: [
                          IconButton(
                            icon: const Icon(
                              Icons.chat_bubble_outline,
                              color: Colors.blue,
                            ),
                            onPressed:
                                () =>
                                    print('💬 ${friend['nickname']}에게 메시지 보내기'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
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
