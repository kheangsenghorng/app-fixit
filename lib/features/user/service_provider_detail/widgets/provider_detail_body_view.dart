import 'package:fixit/features/user/service_provider_detail/widgets/provider_detail_app_bar.dart';
import 'package:flutter/material.dart';
import 'provider_detail_content_view.dart';

class ProviderDetailBodyView extends StatelessWidget {
  final dynamic service;
  final Function(dynamic package) onPackageSelected;

  const ProviderDetailBodyView({
    super.key,
    required this.service,
    required this.onPackageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        ProviderDetailAppBar(
          name: service.title,
          images: service.images,
        ),

        ProviderDetailContentView(
          service: service,
          onPackageSelected: onPackageSelected,
        ),
      ],
    );
  }
}