import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FriendCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final List<Widget> actions;

  const FriendCard({super.key, required this.user, required this.actions});

  @override
  Widget build(BuildContext context) {
    final avatarUrl = user['avatarUrl'];
    final nickname = user['nickname'] ?? '?';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 20,
          backgroundImage:
              avatarUrl != null && avatarUrl.toString().isNotEmpty
                  ? NetworkImage(avatarUrl)
                  : null,
          child:
              avatarUrl == null || avatarUrl.toString().isEmpty
                  ? Text(nickname[0])
                  : null,
        ),
        title: Text(nickname),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: actions),
      ),
    );
  }
}
