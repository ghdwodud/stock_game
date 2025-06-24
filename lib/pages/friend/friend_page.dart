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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'friends',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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

            const SizedBox(height: 20),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: controller.friends.length,
                  itemBuilder: (context, index) {
                    final name = controller.friends[index];
                    return ListTile(
                      title: Text(name),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => controller.removeLocalFriend(name),
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
