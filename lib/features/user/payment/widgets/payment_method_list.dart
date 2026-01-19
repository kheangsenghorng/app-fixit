import 'package:fixit/features/user/payment/widgets/payment_method_tile_content.dart';
import 'package:flutter/material.dart';

class PaymentMethodList extends StatelessWidget {
  final List<Map<String, String>> methods;
  final String selectedMethod;
  final Function(String) onSelect;

  const PaymentMethodList({
    super.key,
    required this.methods,
    required this.selectedMethod,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0056D2);
    const Color selectedBg = Color(0xFFF0F5FF);
    const Color unselectedBorder = Color(0xFFE0E0E0);

    return Expanded(
      child: ListView.builder(
        itemCount: methods.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final method = methods[index];
          final name = method['name']!;
          bool isSelected = selectedMethod == name;
          final icon = method['icon'];


          return GestureDetector(
            onTap: () => onSelect(name),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? selectedBg : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isSelected ? primaryBlue : unselectedBorder,
                    width: 1.5),
              ),
              // The "Cut" logic implemented:
              child: PaymentMethodTileContent(
                name: name,
                icon: icon,
                isSelected: isSelected,
              ),
            ),
          );
        },
      ),
    );
  }
}