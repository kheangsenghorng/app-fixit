import 'dart:ui'; // REQUIRED for ImageFilter
import 'package:flutter/material.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  double _ratingValue = 3.0;
  RangeValues _priceRange = const RangeValues(10, 500);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // THEME COLORS (Matches Header/BottomBar)
    final contentColor = isDark ? Colors.white : Colors.black;
    final activeColor = theme.colorScheme.primary; // Your Unit Blue
    final glassColor = isDark 
        ? const Color(0xFF1A1A1A).withValues(alpha: 0.8) 
        : Colors.white.withValues(alpha: 0.8);
    final borderColor = isDark 
        ? Colors.white.withValues(alpha: 0.1) 
        : Colors.black.withValues(alpha: 0.05);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: glassColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // 1. DRAG HANDLE (Subtle Monochrome)
              Container(
                width: 40, height: 4, 
                decoration: BoxDecoration(
                  color: contentColor.withValues(alpha: 0.1), 
                  borderRadius: BorderRadius.circular(2)
                )
              ),
              
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  children: [
                    // TITLE (Premium Heavy Weight)
                    Text(
                      "Search Filter", 
                      style: TextStyle(
                        color: contentColor, 
                        fontSize: 22, 
                        fontWeight: FontWeight.w900, 
                        letterSpacing: -0.5
                      )
                    ),
                    const SizedBox(height: 35),
                    
                    _buildSectionHeader("Price Range", contentColor),
                    RangeSlider(
                      values: _priceRange,
                      max: 500,
                      divisions: 50,
                      activeColor: activeColor,
                      inactiveColor: contentColor.withValues(alpha: 0.1),
                      onChanged: (val) => setState(() => _priceRange = val),
                    ),
                    
                    const SizedBox(height: 30),
                    _buildSectionHeader("Minimum Rating", contentColor),
                    Slider(
                      value: _ratingValue,
                      max: 5,
                      divisions: 5,
                      activeColor: activeColor,
                      inactiveColor: contentColor.withValues(alpha: 0.1),
                      label: _ratingValue.round().toString(),
                      onChanged: (val) => setState(() => _ratingValue = val),
                    ),
                  ],
                ),
              ),

              // 2. APPLY BUTTON (Stadium/Pill Shape)
              Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, MediaQuery.of(context).padding.bottom + 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: activeColor,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Apply Filter", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: color.withValues(alpha: 0.4),
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}