import 'package:flutter/material.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/provider_appbar_actions.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/provider_flexible_space.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/provider_header.dart';

class ProviderDetailAppBar extends StatelessWidget {
  final String name;
  final String imageUrl;

  const ProviderDetailAppBar({
    super.key,
    required this.name,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      pinned: true,
      stretch: true,
      expandedHeight: 380,
      backgroundColor: colorScheme.surface,
      elevation: 0,
      surfaceTintColor: colorScheme.surface,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white.withValues(alpha: 0.9),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 8),
          child: ProviderAppBarActions(),
        ),
      ],
      flexibleSpace: ProviderFlexibleSpace(
        title: name,
        stretchModes: const [StretchMode.zoomBackground],
        background: ProviderHeader(imageUrl: imageUrl),
      ),
    );
  }
}