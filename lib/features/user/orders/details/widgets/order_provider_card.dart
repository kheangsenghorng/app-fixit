import 'package:flutter/material.dart';


import '../../data/model/booking_providers_response.dart';
import 'circle_action_button.dart';
import 'order_section_card.dart';

class OrderProviderCard extends StatelessWidget {
  final ServiceBookingProvider bookingProvider;

  const OrderProviderCard({
    super.key,
    required this.bookingProvider,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = bookingProvider.provider.user;

    return OrderSectionCard(
      title: "Service Provider",
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: user.avatar != null && user.avatar!.isNotEmpty
                ? NetworkImage(user.avatar!)
                : null,
            child: user.avatar == null || user.avatar!.isEmpty
                ? Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : "?",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            )
                : null,
          ),
          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${bookingProvider.role} • ${bookingProvider.status}",
                  style: textTheme.bodyMedium,
                ),
                Text(
                  user.phone,
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),

          CircleActionButton(
            icon: Icons.phone,
            color: Colors.green,
            onPressed: () {
              // TODO: call user.phone
            },
          ),
          const SizedBox(width: 10),
          CircleActionButton(
            icon: Icons.chat_bubble,
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              // TODO: open chat
            },
          ),
        ],
      ),
    );
  }
}