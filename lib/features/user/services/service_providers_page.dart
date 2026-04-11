import 'package:fixit/features/user/services/providers/providers_page.dart';
import 'package:fixit/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:fixit/widgets/main_bottom_nav.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/models/type_model.dart';
import '../../../../core/provider/type_listener_provider.dart';
import '../main_screen.dart';
import '../search/data/providers/types_provider.dart';


class ServiceProvidersPage extends ConsumerStatefulWidget {
  final int currentIndex;
  final Function(int)? onNavTap;


  const ServiceProvidersPage({
    super.key,
    required this.currentIndex,
    this.onNavTap,
  });

  @override
  ConsumerState<ServiceProvidersPage> createState() =>
      _ServiceProvidersPageState();
}

class _ServiceProvidersPageState extends ConsumerState<ServiceProvidersPage> {
  // ── same background colors used in ProvidersPage ──────────────────
  final List<Color> _bgColors = const [
    Color(0xFFE8D5F5),
    Color(0xFFE5D5C5),
    Color(0xFFD5F5E3),
    Color(0xFFF5F1D5),
    Color(0xFFD5D9F5),
    Color(0xFFD5F5F0),
  ];

  @override
  void initState() {
    super.initState();
    // ── fetch data exactly like ProvidersPage ─────────────────────────
    Future.microtask(() {
      ref.read(typeProvider.notifier).loadInitialTypes();
    });
  }

  /// Map a [TypeModel] → [ProviderModel] (same logic as ProvidersPage)
  ProviderModel _mapType(TypeModel type, int index) {
    return ProviderModel(
      name: type.name,
      category: type.category!.name,
      rating: 4.5,
      bgColor: _bgColors[index % _bgColors.length],
      imageUrl: type.icon.isNotEmpty ? type.icon : null,
      typeId: type.id, // add this
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;


    // ── listen for real-time updates ──────────────────────────────────
    ref.watch(typeListenerProvider);
    final state = ref.watch(typeProvider);

    // ── group types by category name ──────────────────────────────────
    final Map<String, List<TypeModel>> grouped = {};
    for (final type in state.types) {
      final key = type.category?.name;
      grouped.putIfAbsent(key!, () => []).add(type);
    }

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
          'Category Service',
          style: theme.textTheme.headlineMedium,
        ),
      ),
      body: Builder(builder: (_) {
        // ── loading ───────────────────────────────────────────────────
        if (state.isLoading && state.types.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // ── error ─────────────────────────────────────────────────────
        if (state.error != null && state.types.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Failed to load providers.\n${state.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        // ── empty ─────────────────────────────────────────────────────
        if (grouped.isEmpty) {
          return const Center(child: Text('No providers found'));
        }

        // ── content ───────────────────────────────────────────────────
        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(typeProvider.notifier).refresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: grouped.entries.map((entry) {
                final categoryName = entry.key;
                final types = entry.value;
                final providers = types
                    .asMap()
                    .entries
                    .map((e) => _mapType(e.value, e.key))
                    .toList();

                return _buildCategorySection(
                  context,
                  title: categoryName,
                  providers: providers,
                  categoryId: types.first.category?.id,
                );
              }).toList(),
            ),
          ),
        );
      }),
      bottomNavigationBar: MainBottomNav(
        currentIndex: widget.currentIndex,
        onTap: (index) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => MainScreen(currentIndex: index),
            ),
                (route) => false,
          );
        },
      ),
    );
  }

  Widget _buildCategorySection(
      BuildContext context, {
        required String title,
        required List<ProviderModel> providers,
        int? categoryId,
        String buttonText = 'Details',
      }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProvidersPage(
                        serviceName: title,
                        categoryId: categoryId,
                        currentIndex: widget.currentIndex,
                        onNavTap: widget.onNavTap,
                      ),
                    ),
                  );
                },
                child: Text(
                  'View all',
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
                currentIndex: widget.currentIndex,
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
  final int currentIndex;

  const ProviderCard({
    super.key,
    required this.provider,
    required this.buttonText,
    required this.currentIndex,
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
                    Icon(Icons.star, size: 16, color: theme.colorScheme.primary),
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
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.serviceCard,
                      arguments: {
                        'nameType': provider.name,
                        'typeId': provider.typeId,
                        'currentIndex': currentIndex,
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

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
      errorBuilder: (context, error, stackTrace) => _fallbackAvatar(),
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
  final int? typeId; // add this


  ProviderModel({
    required this.name,
    required this.category,
    required this.rating,
    required this.bgColor,
    this.imageUrl,
    this.typeId, // add this
  });
}
