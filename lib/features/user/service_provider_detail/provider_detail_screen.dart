import 'package:fixit/features/user/service_provider_detail/widgets/provider_detail_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/floating_booking_button.dart';

import 'data/service/service_by_id_provider.dart';
import 'widgets/provider_detail_content_view.dart';

class ProviderDetailScreen extends ConsumerStatefulWidget {
  const ProviderDetailScreen({super.key});

  @override
  ConsumerState<ProviderDetailScreen> createState() =>
      _ProviderDetailScreenState();
}

class _ProviderDetailScreenState extends ConsumerState<ProviderDetailScreen> {
  dynamic selectedPackage;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is! int) {
      return const Scaffold(
        body: Center(
          child: Text('Invalid service id'),
        ),
      );
    }

    final int serviceId = args;
    final serviceAsync = ref.watch(serviceByIdProvider(serviceId));
    final theme = Theme.of(context);

    Future<void> refreshService() async {
      setState(() {
        selectedPackage = null;
      });

      ref.invalidate(serviceByIdProvider(serviceId));
      await ref.read(serviceByIdProvider(serviceId).future);
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: serviceAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (error, stackTrace) {
          return RefreshIndicator(
            onRefresh: refreshService,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 56,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Failed to load service',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            error.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              ref.invalidate(serviceByIdProvider(serviceId));
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Try Again'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },

        data: (service) {
          final bookingPackage = selectedPackage ??
              (service.servicePackages.isNotEmpty
                  ? service.servicePackages.first
                  : null);

          return RefreshIndicator(
            onRefresh: refreshService,
            child: Stack(
              children: [
                CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    ProviderDetailAppBar(
                      name: service.title,
                      images: service.images,
                    ),

                    ProviderDetailContentView(
                      service: service,
                      onPackageSelected: (package) {
                        setState(() {
                          selectedPackage = package;
                        });
                      },
                    ),
                  ],
                ),

                Positioned(
                  bottom: 24,
                  left: 24,
                  right: 24,
                  child: FloatingBookingButton(
                    providerData: {
                      ...service.toJson(),
                      'selected_package': bookingPackage?.toJson(),
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}