import 'package:fixit/features/user/services/providers/providers_page.dart';
import 'package:fixit/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:fixit/widgets/main_bottom_nav.dart';


class ServiceProvidersPage extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onNavTap;
  final String serviceName;

  const ServiceProvidersPage({
    super.key,
    required this.currentIndex,
    this.onNavTap,
    required this.serviceName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Service Providers',
          style: theme.textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            _buildCategorySection(
              context,
              title: "Electrician Providers",
              icon: "⚡",
              providers: [
                ProviderModel(
                  name: "Jackson",
                  category: "Electrician",
                  rating: 3.9,
                  bgColor: const Color(0xFFE8D5F5),
                  imageUrl: "assets/images/providers/img.png",
                ),
                ProviderModel(
                  name: "Emily Jani",
                  category: "Electrician",
                  rating: 4.8,
                  bgColor: const Color(0xFFF5E1D5),
                  imageUrl: "assets/images/providers/img_1.png",
                ),
              ],
            ),
            _buildCategorySection(
              context,
              title: "Plumber Providers",
              icon: "🔧",
              providers: [
                ProviderModel(
                  name: "Ethan Lita",
                  category: "Plumber",
                  rating: 4.7,
                  bgColor: const Color(0xFFD5F5E3),
                  imageUrl: "assets/images/providers/img_2.png",
                ),
                ProviderModel(
                  name: "Isabella Una",
                  category: "Plumber",
                  rating: 3.9,
                  bgColor: const Color(0xFFF5F1D5),
                  imageUrl: "assets/images/providers/img_3.png",
                ),
              ],
            ),
            _buildCategorySection(
              context,
              title: "Carpenter Providers",
              icon: "🪵",
              providers: [
                ProviderModel(
                  name: "Aiden",
                  category: "Carpenter",
                  rating: 3.8,
                  bgColor: const Color(0xFFD5D9F5),
                  imageUrl: "assets/images/providers/img_4.png",
                ),
                ProviderModel(
                  name: "Logan",
                  category: "Carpenter",
                  rating: 4.4,
                  bgColor: const Color(0xFFD5F5F0),
                  imageUrl: "assets/images/providers/img_5.png",
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: MainBottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          if (onNavTap != null) {
            onNavTap!(index);
          }
        },
      ),
    );
  }

  Widget _buildCategorySection(
      BuildContext context, {
        required String title,
        required String icon,
        required List<ProviderModel> providers,
        String buttonText = "Details",
      }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(icon, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProvidersPage(
                        serviceName: title,
                        currentIndex: currentIndex,
                        onNavTap: onNavTap,
                      ),
                    ),
                  );
                },
                child: Text(
                  "View all",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16),
            itemCount: providers.length,
            itemBuilder: (context, index) {
              return ProviderCard(
                provider: providers[index],
                buttonText: buttonText,
              );
            },
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}

class ProviderCard extends StatelessWidget {
  final ProviderModel provider;
  final String buttonText;

  const ProviderCard({
    super.key,
    required this.provider,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 190,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.3)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FLEXIBLE IMAGE
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: provider.bgColor,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _buildProviderImage(),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              provider.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              provider.category,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.star,
                        size: 16, color: theme.colorScheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      provider.rating.toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),

                // --- NAVIGATION WRAPPER ADDED HERE ---
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.providerDetail,
                      arguments: {
                        'name': provider.name,
                        'category': provider.category,
                        'image': provider.imageUrl, // This is where the image "takes"

                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      buttonText,
                      style: theme.textTheme.labelLarge
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                // -------------------------------------
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Handles both asset & network images safely
  Widget _buildProviderImage() {
    final imageUrl = provider.imageUrl;

    if (imageUrl == null || imageUrl.isEmpty) {
      return _fallbackAvatar();
    }

    if (imageUrl.startsWith('assets/')) {
      return Image.asset(
        imageUrl,
        width: double.infinity,
        height: double.infinity,

      );
    }

    return Image.network(
      imageUrl,
      width: double.infinity,
      height: double.infinity,

      errorBuilder: (_, __, ___) => _fallbackAvatar(),
    );
  }

  Widget _fallbackAvatar() {
    return Center(
      child: Icon(
        Icons.person,
        size: 70,
        color: Colors.white.withValues(alpha: 0.6),
      ),
    );
  }
}

class ProviderModel {
  final String name;
  final String category;
  final double rating;
  final Color bgColor;
  final String? imageUrl;

  ProviderModel({
    required this.name,
    required this.category,
    required this.rating,
    required this.bgColor,
    this.imageUrl,
  });
}
