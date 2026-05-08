import 'package:flutter/material.dart';

class ServicePriceCard extends StatelessWidget {
  final String? title;
  final String? duration;
  final String? technicians;
  final String? price;
  final int? minArea;
  final int? maxArea;
  final int? floorNumber;
  final int? bedrooms;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onInfoPressed;

  const ServicePriceCard({
    super.key,
    this.title,
    this.duration,
    this.technicians,
    this.price,
    this.minArea,
    this.maxArea,
    this.floorNumber,
    this.bedrooms,
    this.isSelected = false,
    this.onTap,
    this.onInfoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF4F8FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF3F7AF6) : Colors.grey.shade200,
            width: 2,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.blue.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Title and Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title ?? 'Standard Plan',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3F7AF6)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price != null ? (price!.contains('\$') ? price! : '\$$price') : '\$0',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1D2129)),
                    ),
                    const Text("Base price", style: TextStyle(color: Colors.grey, fontSize: 11, fontStyle: FontStyle.italic)),
                  ],
                ),
              ],
            ),

            // Subtitle
            Text(
              "Ideal for ${minArea}m² - ${maxArea}m²",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1, color: Color(0xFFE5E7EB)),
            ),

            // Detail Grid
            Row(
              children: [
                Expanded(child: _buildDetailItem(Icons.apartment_outlined, "Floor", "${floorNumber ?? 01}")),
                Expanded(child: _buildDetailItem(Icons.home_outlined, "Bedrooms", "${bedrooms ?? 0}")),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildDetailItem(Icons.access_time, null, "${duration ?? '0.00'} hours")),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(child: _buildDetailItem(Icons.people_outline, null, "$technicians")),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.info, color: Color(0xFFB0B8C1), size: 22),
                        onPressed: onInfoPressed,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String? label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF3F7AF6), size: 20),
        const SizedBox(width: 8),
        Text(
          label != null ? "$label: " : "",
          style: const TextStyle(color: Color(0xFF4B5563), fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1F2937), fontSize: 14),
        ),
      ],
    );
  }
}