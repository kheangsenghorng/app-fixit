import 'package:flutter/material.dart';

class CustomHeaderBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final bool showBackButton; // 🔥 Added this
  final VoidCallback? onBackPress;

  const CustomHeaderBar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.showBackButton = true, // 🔥 Default is true
    this.onBackPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      centerTitle: centerTitle,
      // 🔥 This line removes the back arrow if showBackButton is false
      automaticallyImplyLeading: showBackButton,

      title: Text(
        title,
        style: theme.textTheme.headlineMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      iconTheme: IconThemeData(color: colorScheme.onSurface),
      // Optional: Manually set the back icon if showBackButton is true
      leading: showBackButton ? IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        onPressed: onBackPress ?? () => Navigator.of(context).pop(),
      ) : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}