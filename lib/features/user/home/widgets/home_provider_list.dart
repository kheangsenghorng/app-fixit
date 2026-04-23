import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/provider/service_provider.dart';
import 'provider_card.dart';

class HomeProviderList extends ConsumerWidget {
  const HomeProviderList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(serviceNotifierProvider);

    return servicesAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('Error: $error'),
        ),
      ),
      data: (services) {
        if (services.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: Text('No services found'),
            ),
          );
        }

        // We use GridView.builder for 2 cards per row
        return GridView.builder(
          shrinkWrap: true, // Allows it to be used inside a Column or ListView
          physics: const BouncingScrollPhysics(), // Smooth scrolling
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,          // 2 cards per row
            mainAxisSpacing: 16,        // Vertical space between rows
            crossAxisSpacing: 16,       // Horizontal space between cards
            childAspectRatio: 0.72,     // Adjust this to fit your ProviderCard height/width ratio
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return ProviderCard(
              service: service,
            );
          },
        );
      },
    );
  }
}