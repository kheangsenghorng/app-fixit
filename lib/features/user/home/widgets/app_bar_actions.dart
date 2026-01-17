import 'package:flutter/material.dart';

class AppBarActions extends StatelessWidget {
  const AppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min, // Takes up only as much space as needed
      children: [
        IconButton(
          icon: Icon(
            Icons.notifications_none_rounded,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () {
            // Add notification logic here
          },
        ),
        IconButton(
          icon: Icon(
            Icons.phone_outlined,
            color: theme.colorScheme.primary,
          ),
          onPressed: () {
            // Add phone/contact logic here
          },
        ),
      ],
    );
  }
}