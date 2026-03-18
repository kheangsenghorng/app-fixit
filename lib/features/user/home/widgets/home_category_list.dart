import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('No categories found'));
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final item = categories[index];

              return Padding(
                padding: const EdgeInsets.only(right: 15),
                child: CategoryCard(
                  title: item.name,
                  image: item.icon,
                  icon: null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProvidersPage(
                          serviceName: item.name,
                          currentIndex: currentIndex,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}