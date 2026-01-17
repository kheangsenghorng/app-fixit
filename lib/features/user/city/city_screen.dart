import 'package:fixit/features/user/city/widgets/provider_section.dart';
import 'package:flutter/material.dart';
// Replace these with your actual model and widget imports
// import '../widgets/provider_section.dart';

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
          // 1. Service Type Filter Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Service Type",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCategoryList(theme, colorScheme),
                ],
              ),
            ),
          ),

          // 2. Dynamic Provider Sections
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (selectedCategory == "ALL" || selectedCategory == "Electrician")
                  const ProviderSection(title: "Electrician Providers", category: "Electrician"),
                if (selectedCategory == "ALL" || selectedCategory == "Plumber")
                  const ProviderSection(title: "Plumber Providers", category: "Plumber"),
                if (selectedCategory == "ALL" || selectedCategory == "Carpenter")
                  const ProviderSection(title: "Carpenter Providers", category: "Carpenter"),
                if (selectedCategory == "ALL" || selectedCategory == "Painter")
                  const ProviderSection(title: "Painter Providers", category: "Painter"),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(ThemeData theme, ColorScheme colorScheme) {
    final categories = ["ALL", "Electrician", "Plumber", "Carpenter", "Painter"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          bool isSelected = selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (_) => setState(() => selectedCategory = cat),
              selectedColor: colorScheme.primary,
              // Handles text color switch between selected and unselected states
              labelStyle: theme.textTheme.labelLarge?.copyWith(
                color: isSelected ? Colors.white : colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isSelected ? colorScheme.primary : Colors.grey.withValues(alpha: 0.3),
                ),
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }
}