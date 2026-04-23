import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fixit/widgets/main_bottom_nav.dart';

import '../../../../routes/app_routes.dart';
import '../../main_screen.dart';
import '../../../../../../core/models/service_model.dart';
import '../providers/data/provider/service_notifier_provider.dart';

class ServiceCard extends ConsumerStatefulWidget {
  final String nameType;
  final int typeId;
  final int currentIndex;
  final Function(int)? onNavTap;

  const ServiceCard({
    super.key,
    required this.nameType,
    required this.typeId,
    required this.currentIndex,
    this.onNavTap,
  });

  @override
  ConsumerState<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends ConsumerState<ServiceCard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(serviceNotifierProvider.notifier).fetchByType(widget.typeId);
    });
  }

  Future<void> _refresh() async {
    await ref.read(serviceNotifierProvider.notifier).refreshServices();
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(serviceNotifierProvider);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.width > 600;

    int crossAxisCount = isTablet ? (size.width > 900 ? 4 : 3) : 2;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.nameType,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: servicesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _buildErrorState(),
          data: (services) {
            if (services.isEmpty) return _buildEmptyState();

            return GridView.builder(
              padding: EdgeInsets.all(isTablet ? 24 : 16),
              itemCount: services.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                // Adjusted ratio to ensure "View Detail" button doesn't overflow
                childAspectRatio: isTablet ? 0.72 : 0.64,
              ),
              itemBuilder: (context, index) => _buildServiceItem(context, services[index], isTablet, theme),
            );
          },
        ),
      ),
      bottomNavigationBar: MainBottomNav(
        currentIndex: widget.currentIndex,
        onTap: (index) {
          if (widget.onNavTap != null) {
            widget.onNavTap!(index);
            return;
          }
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => MainScreen(currentIndex: index)),
                (route) => false,
          );
        },
      ),
    );
  }

  Widget _buildServiceItem(BuildContext context, Service item, bool isTablet, ThemeData theme) {
    final imageUrl = item.images.isNotEmpty ? item.images.first.url : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. IMAGE SECTION
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AspectRatio(
              aspectRatio: 1.3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: imageUrl != null
                        ? Image.network(imageUrl, width: double.infinity, height: double.infinity, fit: BoxFit.cover)
                        : Container(color: theme.colorScheme.surfaceVariant),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.category.name.toUpperCase(),
                        style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. CONTENT SECTION
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, height: 1.1),
                  ),
                  const SizedBox(height: 6),

                  // Provider Info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 9,
                        backgroundImage: (item.owner.logo != null) ? NetworkImage(item.owner.logo!) : null,
                        child: item.owner.logo == null ? const Icon(Icons.person, size: 10) : null,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item.owner.businessName,
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Price and Duration
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${item.basePrice}",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: isTablet ? 18 : 15,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.timer_outlined, size: 12, color: Colors.grey[500]),
                          const SizedBox(width: 2),
                          Text(
                            "${item.duration}m",
                            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 38,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.providerDetail, arguments: item.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C2738),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('View Detail', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.layers_clear_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("No services found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _refresh, child: const Text("Retry")),
        ],
      ),
    );
  }
}