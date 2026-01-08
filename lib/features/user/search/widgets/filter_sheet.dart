import 'package:flutter/material.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  double _ratingValue = 3.0;
  RangeValues _priceRange = const RangeValues(10, 500);
  String _selectedServiceType = "ALL";
  String _selectedAvailability = "specific times";
  String _selectedExperience = "ALL";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: colorScheme.surface, // Uses theme surface color
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(width: 15),
              Text(
                "Search Filter",
                style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Reset logic here
                },
                child: Text("Reset", style: TextStyle(color: colorScheme.primary)),
              )
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _buildSectionTitle(context, "Service Type"),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: ["ALL", "wiring", "repairs", "emergency"].map((type) {
                    return _buildChoiceChip(context, type, _selectedServiceType == type, (val) {
                      setState(() => _selectedServiceType = type);
                    });
                  }).toList(),
                ),

                _buildSectionTitle(context, "Availability"),
                Row(
                  children: [
                    Expanded(
                      child: _selectableCard(
                        context,
                        "Electrician Urgently",
                        Icons.bolt,
                        _selectedAvailability == "Urgently",
                            () => setState(() => _selectedAvailability = "Urgently"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _selectableCard(
                        context,
                        "Specific times",
                        Icons.calendar_month,
                        _selectedAvailability == "specific times",
                            () => setState(() => _selectedAvailability = "specific times"),
                      ),
                    ),
                  ],
                ),

                _buildSectionTitle(context, "Minimum Rating"),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _ratingValue,
                        max: 5,
                        divisions: 5,
                        activeColor: colorScheme.primary,
                        inactiveColor: colorScheme.surfaceContainerHighest,
                        label: _ratingValue.round().toString(),
                        onChanged: (val) => setState(() => _ratingValue = val),
                      ),
                    ),
                    Text(
                      "${_ratingValue.toInt()} Stars",
                      style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                _buildSectionTitle(context, "Price Range (per hour)"),
                RangeSlider(
                  values: _priceRange,
                  max: 500,
                  divisions: 50,
                  activeColor: colorScheme.primary,
                  inactiveColor: colorScheme.surfaceContainerHighest,
                  labels: RangeLabels("\$${_priceRange.start.round()}", "\$${_priceRange.end.round()}"),
                  onChanged: (val) => setState(() => _priceRange = val),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("\$${_priceRange.start.round()}", style: textTheme.bodySmall),
                      Text("\$${_priceRange.end.round()}", style: textTheme.bodySmall),
                    ],
                  ),
                ),

                _buildSectionTitle(context, "Experience Level"),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: ["ALL", "1 Year", "2 Years", "3 Years", "5+ Years"].map((exp) {
                    return _buildChoiceChip(context, exp, _selectedExperience == exp, (val) {
                      setState(() => _selectedExperience = exp);
                    });
                  }).toList(),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),

          // Action Button
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text("Apply Filter", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildChoiceChip(BuildContext context, String label, bool isSelected, Function(bool) onSelected) {
    final colorScheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      showCheckmark: false,
      selectedColor: colorScheme.primary,
      backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      labelStyle: TextStyle(
        color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
    );
  }

  Widget _selectableCard(BuildContext context, String label, IconData icon, bool isSelected, VoidCallback onTap) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? colorScheme.onPrimary : colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}