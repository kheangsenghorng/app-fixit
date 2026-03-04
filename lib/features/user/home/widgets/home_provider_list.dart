import 'package:flutter/material.dart';
import 'provider_card.dart'; // Ensure this is the Radius 32 version we built

class HomeProviderList extends StatelessWidget {
  const HomeProviderList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // 1. INCREASED HEIGHT for the new Radius 32 cards
      height: 260, 
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(), // Premium smooth scrolling
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _providerItem(
            "Maskot Kota",
            "Plumber",
            "assets/images/providers/img.png",
          ),
          _providerItem(
            "Shams Jan",
            "Electrician",
            "assets/images/providers/img.png",
          ),
          _providerItem(
            "Lucas Scott",
            "Painter",
            "assets/images/providers/img.png",
          ),
          _providerItem(
            "Jackson",
            "Mechanic",
            "assets/images/providers/img.png",
          ),
        ],
      ),
    );
  }

  Widget _providerItem(String name, String job, String image) {
    return Padding(
      padding: const EdgeInsets.only(right: 16), // Balanced spacing
      child: SizedBox(
        width: 185, // Fixed width for horizontal consistency
        child: ProviderCard(
          name: name,
          job: job,
          imagePath: image,
          // Note: bgColor is removed to keep the Pure Black/White theme
        ),
      ),
    );
  }
}