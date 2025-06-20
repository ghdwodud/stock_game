import 'package:com.jyhong.stock_game/common/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final List<String> friends = ['alice', 'bob', 'charlie'];
  final TextEditingController _controller = TextEditingController();

  void _addFriend() {
    final name = _controller.text.trim();
    if (name.isNotEmpty && !friends.contains(name)) {
      setState(() {
        friends.add(name);
        _controller.clear();
      });
      Get.snackbar('Success', '$name added as a friend');
    }
  }

  void _removeFriend(String name) {
    setState(() {
      friends.remove(name);
    });
    Get.snackbar('Removed', '$name removed from friends');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'friends'.tr),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter friend username',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed: _addFriend,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final name = friends[index];
                  return ListTile(
                    title: Text(name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeFriend(name),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
