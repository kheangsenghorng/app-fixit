import 'package:fixit/features/user/service_provider_detail/widgets/provider_detail_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/provider_detail_content_view.dart';

class ProviderDetailBodyView extends StatelessWidget {
  final String name;
  final String category;
  final String imageUrl;
  final String rating;

  const ProviderDetailBodyView({
    super.key,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // --- 1. Sticky/Expanding Header ---
        ProviderDetailAppBar(
          name: name,
          imageUrl: imageUrl,
        ),

        // --- 2. Main Body Content ---
        ProviderDetailContentView(
          name: name,
          category: category,
          rating: rating,
        ),
      ],
    );
  }
}