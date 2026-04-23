import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/models/category_model.dart';
import '../../services/providers/providers_page.dart';
import '../data/provider/category_provider.dart';
import 'category_card.dart';

class HomeCategoryList extends ConsumerWidget {
  final int currentIndex;

  const HomeCategoryList({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryNotifierProvider);

    return SizedBox(
      height: 110,
      child: categoriesAsync.when(
        skipLoadingOnReload: true,
        skipError: true,
        loading: () {
          final previous = categoriesAsync.valueOrNull;
          if (previous != null && previous.isNotEmpty) {
            return _buildCategoryList(context, previous);
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          final previous = categoriesAsync.valueOrNull;
          if (previous != null && previous.isNotEmpty) {
            return _buildCategoryList(context, previous);
          }

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    ref.read(categoryNotifierProvider.notifier).refreshCategories();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(
              child: Text('No categories found'),
            );
          }

          return _buildCategoryList(context, categories);
        },
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, List<Category> categories) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: categories.length,
      separatorBuilder: (_, __) => const SizedBox(width: 15),
      itemBuilder: (context, index) {
        final item = categories[index];

        return CategoryCard(
          title: item.name,
          image: item.icon,
          icon: item.icon.isEmpty ? Icons.category : null,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProvidersPage(
                  serviceName: item.name,
                  categoryId: item.id,
                  currentIndex: currentIndex,
                ),
              ),
            );
          },
        );
      },
    );
  }
}