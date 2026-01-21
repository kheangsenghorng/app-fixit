import 'package:flutter/material.dart';

class ErrorTitleText extends StatelessWidget {
  final String title;

  const ErrorTitleText({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        // You can also add a specific color here if needed
        // color: Theme.of(context).colorScheme.error,
      ),
    );
  }
}