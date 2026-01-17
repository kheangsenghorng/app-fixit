import 'package:flutter/material.dart';
import 'provider_card.dart';

class HomeProviderList extends StatelessWidget {
  const HomeProviderList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        // Matching the 20px horizontal padding of your screen
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _providerItem(
            "Maskot Kota",
            "Plumber",
            "assets/images/providers/img.png",
            const Color(0xFFE8D5F5),
          ),
          _providerItem(
            "Maskot Kota",
            "Plumber",
            "assets/images/providers/img.png",
            const Color(0xFFE5D5C5),
          ),
          _providerItem(
            "Shams Jan",
            "Electrician",
            "assets/images/providers/img.png",
            const Color(0xFFD5F5E3),
          ),
        ],
      ),
    );
  }

  Widget _providerItem(String name, String job, String image, Color bgColor) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: SizedBox(
        width: 180,
        child: ProviderCard(
          name: name,
          job: job,
          imagePath: image,
          bgColor: bgColor,
        ),
      ),
    );
  }
}