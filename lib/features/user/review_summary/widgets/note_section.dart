import 'package:flutter/material.dart';

class NoteSection extends StatelessWidget {
  final TextEditingController controller;

  const NoteSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: 'Add a note for the professional...',
        filled: true,
        fillColor: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}