import 'package:flutter/material.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/floating_booking_button.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/provider_detail_body_view.dart';
import './model/provider_model.dart';



class ProviderDetailScreen extends StatelessWidget {
  const ProviderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Get arguments and parse through the Model
    final args = ModalRoute.of(context)?.settings.arguments;
    final provider = ProviderModel.fromArguments(args);

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // 2. Pass clean data from the model to the BodyView
          ProviderDetailBodyView(
            name: provider.name,
            category: provider.category,
            imageUrl: provider.imageUrl,
            rating: provider.rating,
          ),

          // 3. Use the rawData map from the model for the booking button
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: FloatingBookingButton(providerData: provider.rawData),
          ),
        ],
      ),
    );
  }
}