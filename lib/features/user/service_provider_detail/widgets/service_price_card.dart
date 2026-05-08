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
  final bool isSelected; // Added this
  final VoidCallback? onTap; // Added this
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
    this.isSelected = false, // Default to false
    this.onTap,
    this.onInfoPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // Change background color if selected
          color: isSelected ? Colors.blue.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          // Change border color if selected
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    maxArea != null
                        ? "$title (${minArea}m² - ${maxArea}m²)"
                        : (title ?? 'Service Detail'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.blue : Colors.black, // Color change
                    ),
                  ),
                  if (floorNumber != null || bedrooms != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      "Floor: ${floorNumber ?? 0} | Bedrooms: ${bedrooms ?? 0}",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(duration ?? 'N/A', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(width: 16),
                      const Icon(Icons.people_outline, size: 16, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(technicians ?? '1 Technician', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price != null ? (price!.contains('\$') ? price! : '\$$price') : '\$0',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: isSelected ? Colors.blue : Colors.black, // Color change
                  ),
                ),
                const SizedBox(height: 4),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(Icons.info_outline, color: Colors.blue.shade300, size: 20),
                  onPressed: onInfoPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}