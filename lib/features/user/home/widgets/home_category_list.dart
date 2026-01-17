import 'package:flutter/material.dart';
import '../../services/providers/providers_page.dart';
import 'category_card.dart'; // Import your existing card
// Adjust path as needed

class HomeCategoryList extends StatelessWidget {
  final int currentIndex;

  const HomeCategoryList({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _categoryItem(context, "Plumbing", Icons.plumbing),
          _categoryItem(context, "Electric", Icons.electric_bolt),
          _categoryItem(context, "Solar", Icons.wb_sunny_outlined),
          _categoryItem(context, "Cleaning", Icons.cleaning_services),
        ],
      ),
    );
  }

  Widget _categoryItem(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: CategoryCard(
        title: title,
        icon: icon,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProvidersPage(
                serviceName: title,
                currentIndex: currentIndex,
              ),
            ),
          );
        },
      ),
    );
  }
}