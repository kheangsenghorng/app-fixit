import 'package:flutter/material.dart';

import 'circle_action_button.dart';
import 'order_section_card.dart';

class OrderProviderCard extends StatelessWidget {
  const OrderProviderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return OrderSectionCard(
      title: "Service Provider",
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=a'),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Lucas Scott", style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text("Professional Plumber", style: textTheme.bodyMedium),
              ],
            ),
          ),
          CircleActionButton(icon: Icons.phone, color: Colors.green, onPressed: () {}),
          const SizedBox(width: 10),
          CircleActionButton(
            icon: Icons.chat_bubble,
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}