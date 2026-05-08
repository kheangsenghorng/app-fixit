import 'package:flutter/material.dart';

class ServiceInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const ServiceInfoTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material( // Added Material for the click animation
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16), // Slightly more padding
          child: Row(
            children: [
              Icon(icon, color: Colors.orange.shade400),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20), // Changed to chevron
            ],
          ),
        ),
      ),
    );
  }
}