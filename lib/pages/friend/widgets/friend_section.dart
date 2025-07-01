import 'package:com.jyhong.stock_game/pages/friend/widgets/friend_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FriendSection extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> users;
  final List<Widget> Function(Map<String, dynamic>) actionBuilder;

  const FriendSection({
    super.key,
    required this.title,
    required this.users,
    required this.actionBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...users.map(
          (user) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FriendCard(user: user, actions: actionBuilder(user)),
          ),
        ),
        const Divider(thickness: 1, height: 20),
      ],
    );
  }
}
