import 'package:fixit/features/user/search/widgets/filter_sheet.dart';
import 'package:fixit/features/user/services/widgets/provider_grid_card.dart';
import 'package:fixit/widgets/main_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/models/type_model.dart';
import '../../../../core/provider/type_listener_provider.dart';
import '../../search/data/providers/types_provider.dart';

class ProvidersPage extends ConsumerStatefulWidget {
  final int? categoryId;
  final String serviceName;
  final int? currentIndex;
  final Function(int)? onNavTap;

  const ProvidersPage({
    super.key,
    required this.serviceName,
    required this.categoryId,
    this.currentIndex,
    this.onNavTap,
  });

  @override
  ConsumerState<ProvidersPage> createState() => _ProvidersPageState();
}

class _ProvidersPageState extends ConsumerState<ProvidersPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(typeProvider.notifier).loadInitialTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.categoryId == null) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.serviceName,
            style: theme.textTheme.headlineMedium,
          ),
        ),
        body: const Center(
          child: Text('Category ID is missing'),
        ),
      );
    }

    ref.watch(typeListenerProvider);

    final state = ref.watch(typeProvider);

    final filteredTypes = state.types
        .where((type) => type.category?.id == widget.categoryId)
        .toList();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.serviceName,
          style: theme.textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.tune_rounded, color: theme.iconTheme.color),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const FilterSheet(),
              );
            },
          ),
        ],
      ),
      body: Builder(
        builder: (_) {
          if (state.isLoading && filteredTypes.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.error != null && filteredTypes.isEmpty) {
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

          if (filteredTypes.isEmpty) {
            return const Center(
              child: Text('No providers found'),
            );
          }

          final providers = filteredTypes
              .asMap()
              .entries
              .map(
                (entry) => _mapTypeToProviderModel(
              entry.value,
              widget.serviceName,
              entry.key,
            ),
          )
              .toList();

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(typeProvider.notifier).refresh();
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemCount: providers.length,
              itemBuilder: (_, index) =>
                  ProviderGridCard(provider: providers[index]),
            ),
          );
        },
      ),
      bottomNavigationBar: (widget.currentIndex != null &&
          widget.onNavTap != null)
          ? MainBottomNav(
        currentIndex: widget.currentIndex!,
        onTap: (index) {
          widget.onNavTap!(index);
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      )
          : null,
    );
  }

  ProviderModel _mapTypeToProviderModel(
      TypeModel type,
      String serviceName,
      int index,
      ) {
    final colors = <Color>[
      const Color(0xFFE8D5F5),
      const Color(0xFFE5D5C5),
      const Color(0xFFD5F5E3),
      const Color(0xFFF5F1D5),
      const Color(0xFFD5D9F5),
      const Color(0xFFD5F5F0),
    ];

    return ProviderModel(
      name: type.name,
      category: type.category?.name ?? serviceName,
      rating: 4.5,
      bgColor: colors[index % colors.length],
      imageUrl: type.icon.isNotEmpty ? type.icon : null,
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