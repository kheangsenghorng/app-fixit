import 'package:fixit/features/user/service_provider_detail/widgets/provider_detail_app_bar.dart';
import 'package:flutter/material.dart';
import 'provider_detail_content_view.dart';

class ProviderDetailBodyView extends StatelessWidget {
  final dynamic service; // This is the 'data' object from your JSON

  const ProviderDetailBodyView({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Updated to pass 'images' (the list) instead of 'imageUrl' (one string)
        ProviderDetailAppBar(
          name: service.title,
          images: service.images, // Pass the list directly
        ),
        ProviderDetailContentView(service: service),
      ],
    );
  }
}