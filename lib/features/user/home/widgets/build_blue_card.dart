import 'package:flutter/material.dart';


Widget buildBlueCard() {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      // The Background Box
      Container(
        height: 160,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF004AAD),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Get 30% off",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Just by Booking Home\nServices",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.3,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),

      // The Woman Image (Popping out of the top)
      Positioned(
        top: -35, // Moves head above the blue box
        right: 0,
        bottom: 0,
        child: Image.asset(
          'assets/images/providers/img_12.png',
          fit: BoxFit.contain,
          alignment: Alignment.bottomRight,
          height: 200, // Slightly taller than the blue card
        ),
      ),
    ],
  );
}
