import 'package:flutter/material.dart';

class HelpAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color primaryColor;
  final String title;

  const HelpAppBar({
    super.key,
    required this.primaryColor,
    this.title = 'Help & support'
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: primaryColor),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        title,
        style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: Text('Live chat', style: TextStyle(color: primaryColor)),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}