import 'package:flutter/material.dart';


class PromoBanner extends StatelessWidget {
  final VoidCallback onSearchTap;

  const PromoBanner({
    super.key,
    required this.onSearchTap,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 160,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Get 30% off",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                  )),
              SizedBox(height: 8),
              Text("Just by Booking home\nServices", style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        Positioned(
          bottom: -25,
          left: 20,
          right: 20,
          child: Container(
            decoration: BoxDecoration(
              // DYNAMIC: Uses Surface color (White in light, Dark Grey in dark mode)
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  // Adjust shadow opacity based on theme
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withValues(alpha: 0.4)
                      : Colors.black12,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: TextField(
              readOnly: true,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: "Search here",
                hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)
                ),
                prefixIcon: GestureDetector(
                  onTap: onSearchTap,

                  child: Icon(

                    Icons.search,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                suffixIcon: Icon(
                    Icons.tune,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)
                ),
                // We override the global theme borders here to keep the search bar clean
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false, // Don't use the grey fill from the global theme
              ),
            ),
          ),
        ),
      ],
    );
  }
}