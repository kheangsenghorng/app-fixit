import 'package:flutter/material.dart';
import 'provider_section.dart';

class CityProviderList extends StatelessWidget {
  final String selectedCategory;

  const CityProviderList({super.key, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> categories = {
      "Electrician": "Electrician Providers",
      "Plumber": "Plumber Providers",
      "Carpenter": "Carpenter Providers",
      "Painter": "Painter Providers",
    };

    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 20),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          ...categories.entries
              .where((e) => selectedCategory == "ALL" || selectedCategory == e.key)
              .map((e) => ProviderSection(title: e.value, category: e.key))
              ,
        ]),
      ),
    );
  }
}