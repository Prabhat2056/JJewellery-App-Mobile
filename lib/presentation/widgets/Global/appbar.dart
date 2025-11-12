import 'package:flutter/material.dart';
import 'package:jjewellery/presentation/pages/notification_page.dart';
import 'package:jjewellery/presentation/pages/settings_page.dart';

import '../../../utils/color_constant.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppbar({
    super.key,
    required this.isHomeWidget,
    this.title = "J-Jewellery App",
  });
  final bool isHomeWidget;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          // fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      backgroundColor: ColorConstant.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        isHomeWidget
            ? Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => NotificationPage(),
                      ),
                    ),
                    icon: Icon(Icons.notifications_none_outlined),
                    iconSize: 20,
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    ),
                    icon: const Icon(Icons.more_vert_outlined),
                    iconSize: 20,
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
