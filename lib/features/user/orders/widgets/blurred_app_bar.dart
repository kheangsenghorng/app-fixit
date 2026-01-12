import 'dart:ui';
import 'package:flutter/material.dart';

class BlurredAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const BlurredAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.8),
          elevation: 0,
          title: Text(
            title,
            style: const TextStyle(
                fontSize: 26,
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}