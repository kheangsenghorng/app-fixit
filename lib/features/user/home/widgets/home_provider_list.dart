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
      loading: () => const SizedBox(
        height: 260,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => SizedBox(
        height: 260,
        child: Center(
          child: Text('Error: $error'),
        ),
      ),
      data: (services) {
        if (services.isEmpty) {
          return const SizedBox(
            height: 260,
            child: Center(
              child: Text('No services found'),
            ),
          );
        }

        return SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];

              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 185,
                  child: ProviderCard(
                    service: service,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}