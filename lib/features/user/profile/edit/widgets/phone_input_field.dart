import 'package:flutter/material.dart';

class PhoneInputField extends StatelessWidget {
  final String label;
  final String hint;

  const PhoneInputField({super.key, required this.label, required this.hint});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              const Text("🇵🇰", style: TextStyle(fontSize: 20)),
              const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              Container(
                  height: 24, width: 1,
                  color: Colors.grey.shade300,
                  margin: const EdgeInsets.symmetric(horizontal: 10)
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(hintText: hint, border: InputBorder.none),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}