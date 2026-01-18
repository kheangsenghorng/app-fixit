import 'package:flutter/material.dart';

import 'category_filter_bar.dart';
import 'city_section_title.dart';

class CityCategoryFilter extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CityCategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = ["ALL", "Electrician", "Plumber", "Carpenter", "Painter"];

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CitySectionTitle(title: "Service Type"),
            const SizedBox(height: 12),
            // ... inside CityCategoryFilter build method
            CategoryFilterBar(
              categories: categories, // Use the list defined above
              selectedCategory: selectedCategory,
              onCategorySelected: onCategorySelected, // Pass the callback directly
            ),
          ],
        ),
      ),
    );
  }
}