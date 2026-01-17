import 'package:flutter/material.dart';
import 'get_service_screen/get_service_screen.dart';
import 'widgets/filter_sheet.dart';
import 'widgets/provider_card.dart';

class SearchResultScreen extends StatefulWidget {
  final String? query;

  const SearchResultScreen({
    super.key,
    this.query,
  });

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}


class _SearchResultScreenState extends State<SearchResultScreen> {
  // Methods for state logic can go here (e.g. filtering logic)

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            style: TextStyle(color: colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: widget.query ?? "Search",
              hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              prefixIcon: Icon(Icons.search, size: 20, color: colorScheme.onSurfaceVariant),
              suffixIcon: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.tune, size: 20, color: colorScheme.primary),
                onPressed: () => _showFilterSheet(context),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Results for \"${widget.query ?? ''}\"",
              style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
            ),
            const SizedBox(height: 15),

            // 1. Featured Card
            _buildFeaturedServiceCard(context),

            const SizedBox(height: 25),

            // 2. Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.query ?? 'Service'} Providers",
                  style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("View all",
                      style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold)
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // 3. Provider Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 240,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return const ProviderCard(
                  name: "Jackson",
                  job: "Electrician",
                  rating: "4.9",
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),


    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterSheet(),
    );
  }

  Widget _buildFeaturedServiceCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    const onCardColor = Colors.white;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "FEATURED SERVICE",
                      style: TextStyle(
                          color: onCardColor.withValues(alpha: 0.7),
                          fontSize: 11,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${widget.query ?? 'Service'} service",
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: onCardColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.electrical_services, size: 45, color: onCardColor),
            ],
          ),
          const SizedBox(height: 15),
          Divider(color: onCardColor.withValues(alpha: 0.2)),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.orangeAccent, size: 18),
              const Text(" 4.8 (76)", style: TextStyle(color: onCardColor, fontWeight: FontWeight.w600)),
              const Spacer(),
              const Text(
                "\$20/hour",
                style: TextStyle(
                  color: onCardColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(Icons.alarm, color: onCardColor, size: 18),
              const SizedBox(width: 8),
              _buildTimeChip("7:00AM"),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("To", style: TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              _buildTimeChip("10:00PM"),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GetServiceScreen(
                      query: widget.query,

                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: onCardColor,
                foregroundColor: colorScheme.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Get This Service",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeChip(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Text(
        time,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}