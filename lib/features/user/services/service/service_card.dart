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
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.width > 600;
    final bool isLargeTablet = size.width > 900;

    // Responsive Column Logic
    int crossAxisCount = 2;
    if (isLargeTablet) {
      crossAxisCount = 4;
    } else if (isTablet) {
      crossAxisCount = 3;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        toolbarHeight: isTablet ? 80 : 60, // Taller AppBar for iPad
        title: Text(
          widget.nameType,
          style: TextStyle(
            color: const Color(0xFF1E293B),
            fontWeight: FontWeight.w800,
            fontSize: isTablet ? 24 : 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black),
          onPressed: () => Navigator.pop(context),
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
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32 : 16,
                  vertical: 20
              ),
              itemCount: services.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                // Adjusting ratio so cards don't get too long on iPad
                childAspectRatio: isTablet ? 0.75 : 0.62,
              ),
              itemBuilder: (context, index) => _buildServiceItem(context, services[index], isTablet),
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

  Widget _buildServiceItem(BuildContext context, Service item, bool isTablet) {
    final imageUrl = item.images.isNotEmpty ? item.images.first.url : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: imageUrl != null
                      ? Image.network(imageUrl, width: double.infinity, fit: BoxFit.cover)
                      : Container(color: Colors.blueGrey[50]),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.category.name.toUpperCase(),
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content Section
          Expanded(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 16 : 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 16 : 14,
                        height: 1.2
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Provider
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: (item.owner.logo != null) ? NetworkImage(item.owner.logo!) : null,
                        child: item.owner.logo == null ? const Icon(Icons.person, size: 12) : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.owner.businessName,
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          maxLines: 1,
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
                            fontSize: isTablet ? 18 : 16,
                            color: Colors.blueAccent
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.timer_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                              "${item.duration}m",
                              style: const TextStyle(fontSize: 12, color: Colors.grey)
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Action Button
                  // 3. ACTION BUTTON (VIEW DETAIL)
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.providerDetail, arguments: item.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C2738), // Dark Navy matching your image
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('View Detail', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
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
          Icon(Icons.layers_clear_outlined, size: 100, color: Colors.grey[300]),
          const Text("No services found", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
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