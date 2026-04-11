import 'package:fixit/features/user/service_provider_detail/widgets/provider_detail_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/floating_booking_button.dart';
import 'data/service/service_by_id_provider.dart';

import 'widgets/provider_detail_content_view.dart';

class ProviderDetailScreen extends ConsumerWidget {
  const ProviderDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is! int) {
      return const Scaffold(body: Center(child: Text('Invalid service id')));
    }

    final int serviceId = args;
    final serviceAsync = ref.watch(serviceByIdProvider(serviceId));

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: serviceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (service) {
          // 'service' here refers to the 'data' object in your JSON
          return Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  ProviderDetailAppBar(
                    name: service.title,
                    images: service.images, // Pass the list directly
                  ),
                  ProviderDetailContentView(service: service),
                ],
              ),
              Positioned(
                bottom: 24,
                left: 24,
                right: 24,
                child: FloatingBookingButton(
                  providerData: service.toJson(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}