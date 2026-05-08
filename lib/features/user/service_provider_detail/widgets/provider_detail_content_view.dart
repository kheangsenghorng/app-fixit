import 'package:fixit/features/user/service_provider_detail/widgets/service_stat_card.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/task_info_bottom_sheet.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/whats_included_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'service_price_card.dart';
import 'service_info_tile.dart';

class ProviderDetailContentView extends StatefulWidget {
  final dynamic service;
  final Function(dynamic package) onPackageSelected;

  const ProviderDetailContentView({
    super.key,
    required this.service,
    required this.onPackageSelected,
  });

  @override
  State<ProviderDetailContentView> createState() => _ProviderDetailContentViewState();
}

class _ProviderDetailContentViewState extends State<ProviderDetailContentView> {
  int selectedVariantIndex = 0;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final packages = widget.service.servicePackages;

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.service.category.name.toUpperCase(),
                style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const SizedBox(height: 12),

            // Title
            Text(
              widget.service.title,
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Rating/Type Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(16),
              ),
                child: Row(
                  children: [
                    const Expanded(
                      child: ServiceStatCard(
                        icon: Icons.star,
                        label: "Rating",
                        value: "4.92",
                        bgColor: Color(0xFFFFFBEB),
                        iconColor: Color(0xFFFBBF24),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ServiceStatCard(
                        icon: Icons.business_center_outlined,
                        label: "Type",
                        value: widget.service.type.name,
                        bgColor: const Color(0xFFEEF2FF),
                        iconColor: const Color(0xFF6366F1),
                      ),
                    ),
                  ],
                )
            ),

            const SizedBox(height: 24),
            const Text("Service Pricing", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Selectable Price Cards
            if (packages.isEmpty)
              const Text("No packages available")
            else
              ...List.generate(packages.length, (index) {
                final package = packages[index];

                return ServicePriceCard(
                  title: package.title,
                  duration: "${package.durationHours} hours",
                  technicians: "${package.workersCount} Workers",
                  price: package.price,
                  minArea: package.minArea,
                  maxArea: package.maxArea,
                  bedrooms: package.bedrooms,
                  floorNumber: package.floorNumber,
                  isSelected: selectedVariantIndex == index,
                  onTap: () {
                    setState(() {
                      selectedVariantIndex = index;
                    });

                    widget.onPackageSelected(package);
                  },
                  onInfoPressed: () => showTaskInfoBottomSheet(
                    context: context,
                    service: widget.service,
                    selectedVariantIndex: selectedVariantIndex,
                  ),
                );
              }),

             const SizedBox(height: 16),

            // INFO TILES
            ServiceInfoTile(
              icon: Icons.assignment_outlined,
              title: "Task Information",
              onTap: () => showTaskInfoBottomSheet(
                context: context,
                service: widget.service,
                selectedVariantIndex: selectedVariantIndex,
              ),
            ),
            const Divider(height: 1),
            ServiceInfoTile(
              icon: Icons.fact_check_outlined,
              title: "What's included",
              onTap: () => showWhatsIncludedBottomSheet(
                context: context,
                service: widget.service,
                selectedVariantIndex: selectedVariantIndex,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}