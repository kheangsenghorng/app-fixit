import 'package:fixit/features/user/city/widgets/category_filter.dart';
import 'package:fixit/features/user/city/widgets/city_provider_list.dart';
import 'package:flutter/material.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  String selectedCategory = "ALL";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Service Providers",
          style: theme.textTheme.headlineMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // 1. Filter Section
          CityCategoryFilter(
            selectedCategory: selectedCategory,
            onCategorySelected: (cat) => setState(() => selectedCategory = cat),
          ),

          // 2. Providers List
          CityProviderList(selectedCategory: selectedCategory),
        ],
      ),
    );
  }
}