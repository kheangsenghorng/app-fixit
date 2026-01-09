import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  final bool isSelected;
  final Color accentColor;
  const CustomRadioButton({super.key, required this.isSelected, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      width: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? accentColor : Colors.transparent,
        border: Border.all(
          color: isSelected ? accentColor : Colors.grey.shade400,
          width: 2,
        ),
      ),
      child: isSelected
          ? const Icon(Icons.check, size: 14, color: Colors.white)
          : null,
    );
  }
}