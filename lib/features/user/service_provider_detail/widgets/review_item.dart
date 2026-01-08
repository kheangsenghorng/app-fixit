import 'package:flutter/material.dart';

class ReviewItem extends StatelessWidget {
  final String user;
  final String comment;

  const ReviewItem({
    super.key,
    required this.user,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
      ),
      title: Text(user, style: theme.textTheme.titleMedium),
      subtitle: Text(comment),
      trailing: Icon(Icons.star, color: theme.colorScheme.secondary, size: 16),
    );
  }
}
