import 'package:com.jyhong.stock_game/config/config.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double radius;
  final VoidCallback? onTap;
  final bool showEditIcon;

  const UserAvatar({
    super.key,
    required this.avatarUrl,
    this.radius = 30,
    this.onTap,
    this.showEditIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    String? fullUrl;
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      fullUrl =
          avatarUrl!.startsWith('http') ? avatarUrl : '${baseUrl}$avatarUrl';
    }

    final avatarWidget = CircleAvatar(
      radius: radius,
      backgroundImage: fullUrl != null ? NetworkImage(fullUrl) : null,
      child: (fullUrl == null) ? const Icon(Icons.person) : null,
    );

    Widget result = avatarWidget;

    if (showEditIcon) {
      result = Stack(
        alignment: Alignment.center,
        children: [
          avatarWidget,
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, size: 16, color: Colors.white),
            ),
          ),
        ],
      );
    }

    if (onTap != null) {
      result = GestureDetector(onTap: onTap, child: result);
    }

    return result;
  }
}
