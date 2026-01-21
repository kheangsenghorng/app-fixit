import 'package:flutter/material.dart';

class ProviderAccountSwitcher extends StatelessWidget {
  final bool isProvider;
  final VoidCallback onTap;

  const ProviderAccountSwitcher({
    super.key,
    required this.isProvider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // Logic: Blue for existing providers, Orange for new ones
          color: isProvider
              ? Colors.blue.withValues(alpha: 0.1)
              : Colors.orange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isProvider ? Colors.blue.withValues(alpha: 0.3) : Colors.orange.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isProvider ? Colors.blue : Colors.orange,
              child: Icon(
                isProvider ? Icons.verified_user : Icons.storefront,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isProvider ? "Provider Account Active" : "Become a Provider",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    isProvider
                        ? "Manage your services and orders"
                        : "Start earning by offering your skills",
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isProvider ? Colors.blue : Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}