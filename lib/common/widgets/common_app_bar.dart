import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showSettings;
  final List<Widget>? actions;
  final Widget? leading;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showSettings = true,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
       toolbarHeight: 64,
      elevation: 0,
      //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      centerTitle: true,
      iconTheme: const IconThemeData(size: 28),
      title: Text(
        title.tr,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: leading,
      actions: [
        if (actions != null) ...actions!,
        if (showSettings)
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed('/settings'),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}

