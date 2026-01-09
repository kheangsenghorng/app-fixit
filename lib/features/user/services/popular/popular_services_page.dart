
import 'package:fixit/features/user/services/service_providers_page.dart';
import 'package:flutter/material.dart';

import 'package:fixit/widgets/main_bottom_nav.dart';

class PopularServicesPage extends StatefulWidget {
  final int currentIndex;
  final Function(int)? onNavTap;

  const PopularServicesPage({
    super.key,
    required this.currentIndex,
    this.onNavTap,
  });

  @override
  State<PopularServicesPage> createState() => _PopularServicesPageState();
}

class _PopularServicesPageState extends State<PopularServicesPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor:  colorScheme.surface,
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Popular services',
          style: theme.textTheme.headlineMedium,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          _buildCategorySection(
            context,
            'Maintenance',
            [
              ServiceItem('Air Condition', 'assets/images/services/services01.png'),
              ServiceItem('Electric', 'assets/images/services/services02.png'),
              ServiceItem('Siding repair', 'assets/images/services/services03.png'),
              ServiceItem('Kitchen', 'assets/images/services/services02.png'),
            ],
          ),
          _buildCategorySection(
            context,
            'Cleaning',
            [
              ServiceItem('Home Flooring', 'assets/images/services/services01.png'),
              ServiceItem('Gutter', 'assets/images/services/services01.png'),
              ServiceItem('Carpet', 'assets/images/services/services01.png'),
              ServiceItem('Deep Clean', 'assets/images/services/services01.png'),
            ],
          ),
          _buildCategorySection(
            context,
            'Home improvement',
            [
              ServiceItem('Drilling', 'assets/images/services/services01.png'),
              ServiceItem('Lawn', 'assets/images/services/services01.png'),
              ServiceItem('Weed control', 'assets/images/services/services01.png'),
              ServiceItem('Painting', 'assets/images/services/services01.png'),
            ],
          ),
          _buildCategorySection(
            context,
            'Security',
            [
              ServiceItem('Cameras', 'assets/images/services/services01.png'),
              ServiceItem('Burglar alarm', 'assets/images/services/services01.png'),
              ServiceItem('Sturdy lock', 'assets/images/services/services01.png'),
              ServiceItem('Smart Home', 'assets/images/services/services01.png'),
            ],
          ),
          _buildCategorySection(
            context,
            'Car Maintenance',
            [
              ServiceItem('Car washer', 'assets/images/services/services01.png'),
              ServiceItem('Oil change', 'assets/images/services/services01.png'),
              ServiceItem('Car battery', 'assets/images/services/services01.png'),
              ServiceItem('Tires', 'assets/images/services/services01.png'),
            ],
          ),
        ],
      ),
      bottomNavigationBar: MainBottomNav(
        currentIndex: widget.currentIndex,
        onTap: (index) {
          if (widget.onNavTap != null) {
            widget.onNavTap!(index);
          }
        },
      ),

    );
  }

  Widget _buildCategorySection(
      BuildContext context,
      String title,
      List<ServiceItem> items,
      ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 20, bottom: 12),
          child: Text(
            title,
            style: theme.textTheme.titleMedium,
          ),
        ),
        SizedBox(
          height: 130,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) =>
                _buildServiceCard(context, items[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(BuildContext context, ServiceItem item) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ServiceProvidersPage(
              serviceName: item.name,
              currentIndex: widget.currentIndex,
              onNavTap: widget.onNavTap,
            )

          ),
        );
      },
      child: Container(
        width: 110,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.dividerColor.withValues(alpha: 0.4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Image.asset(
                item.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Icon(
                  Icons.build_circle,
                  size: 40,
                  color: theme.dividerColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 2,
              child: Text(
                item.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceItem {
  final String name;
  final String imagePath;

  ServiceItem(this.name, this.imagePath);
}
