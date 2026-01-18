import 'package:flutter/material.dart';

class StarRatingBar extends StatelessWidget {
  final double rating;
  final double starSize;
  final Color color;
  final Function(double) onRatingChanged;

  const StarRatingBar({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    this.starSize = 45,
    this.color = const Color(0xFF0056D2), // Your primaryBlue
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => onRatingChanged(index + 1.0),
          child: Icon(
            index < rating.floor() ? Icons.star : Icons.star_border,
            color: color,
            size: starSize,
          ),
        );
      }),
    );
  }
}