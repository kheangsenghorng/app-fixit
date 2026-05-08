import 'package:flutter/material.dart';
import 'service_price_card.dart';
import 'service_info_tile.dart';

class ProviderDetailContentView extends StatefulWidget {
  final dynamic service;

  const ProviderDetailContentView({super.key, required this.service});

  @override
  State<ProviderDetailContentView> createState() => _ProviderDetailContentViewState();
}

class _ProviderDetailContentViewState extends State<ProviderDetailContentView> {
  int selectedVariantIndex = -1;

  // Mock data for variants
  final List<Map<String, dynamic>> serviceVariants = [
    {'title': '1HP - 1.5HP', 'duration': '1 hour', 'techs': '2 Technicians', 'price': '10'},
    {'title': '2HP', 'duration': '1 hour', 'techs': '2 Technicians', 'price': '15'},
    {
      "title": "Package",
      "min_area_m2": 70,
      "max_area_m2": 100,
      "floor_number": 1,
      "bedrooms": 6,
      "duration": "4 hours",
      "techs": "2 Cleaners",
      "price": "50",
    }
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.service.category.name.toUpperCase(),
                style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const SizedBox(height: 12),

            // Title
            Text(
              widget.service.title,
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Rating/Type Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat(Icons.star, "Rating", "4.8"),
                  _buildStat(Icons.work_outline, "Type", widget.service.type.name),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text("Service Pricing", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Selectable Price Cards
            ...List.generate(serviceVariants.length, (index) {
              final variant = serviceVariants[index];
              return ServicePriceCard(
                title: variant['title'],
                duration: variant['duration'],
                technicians: variant['techs'],
                price: variant['price']?.toString(),
                minArea: variant['min_area_m2'],
                maxArea: variant['max_area_m2'],
                bedrooms: variant['bedrooms'],
                floorNumber: variant['floor_number'],
                isSelected: selectedVariantIndex == index,
                onTap: () => setState(() => selectedVariantIndex = index),
                onInfoPressed: () => _showTaskInfoSheet(context),
              );
            }),

            const SizedBox(height: 16),

            // INFO TILES
            ServiceInfoTile(
              icon: Icons.assignment_outlined,
              title: "Task Information",
              onTap: () => _showTaskInfoSheet(context),
            ),
            const Divider(height: 1),
            ServiceInfoTile(
              icon: Icons.fact_check_outlined,
              title: "What's included",
              onTap: () => _showWhatsIncludedSheet(context),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // --- 1. TASK INFORMATION SHEET (CATEGORY SELECTOR) ---
  void _showTaskInfoSheet(BuildContext context) {
    String selectedCat = "Kitchen";
    final List<String> cats = ["Kitchen", "Bathroom", "Living room"];
    final Map<String, List<String>> tasks = {
      "Kitchen": [
        "Wipe and scrub kitchen stoves",
        "Clean kitchen islands and table tops",
        "Clean the sink",
        "Clearing of thrash",
        "Sweep and mop the floor"
      ],
      "Bathroom": ["Sanitize toilet", "Clean mirrors", "Scrub floor tiles"],
      "Living room": ["Dusting furniture", "Vacuuming carpets", "Cleaning windows"],
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text("Task Information", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // Category Row
              Row(
                children: cats.map((c) {
                  bool isSel = selectedCat == c;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: isSel,
                      onSelected: (val) => setSheetState(() => selectedCat = c),
                      selectedColor: const Color(0xFFE8F0FE),
                      labelStyle: TextStyle(color: isSel ? Colors.blue : Colors.grey),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Task List
              Expanded(
                child: ListView.builder(
                  itemCount: tasks[selectedCat]!.length,
                  itemBuilder: (context, i) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: Colors.blue, size: 18),
                        const SizedBox(width: 12),
                        Expanded(child: Text(tasks[selectedCat]![i])),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- 2. WHAT'S INCLUDED SHEET (GRID OF TOOLS) ---
  void _showWhatsIncludedSheet(BuildContext context) {
    // Note: Replace these with your actual local assets or network URLs
    final List<String> tools = List.generate(9, (index) => 'assets/tool_$index.png');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text("What's included", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: tools.length,
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.image_outlined, color: Colors.grey), // Replace with Image.asset
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}