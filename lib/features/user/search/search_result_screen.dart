import 'dart:ui';
import 'package:flutter/material.dart';
import './get_service_screen/get_service_screen.dart'; 
import 'widgets/filter_sheet.dart';
import 'widgets/provider_card.dart';

class SearchResultScreen extends StatefulWidget {
  final String? query;
  const SearchResultScreen({super.key, this.query});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  int selectedCategoryIndex = 0;

  final List<String> categories = ["All", "Cleaning", "Repair", "Electric", "Plumbing", "Paint"];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // 1. BLACK & WHITE MONOCHROME LOGIC
    final scaffoldBg = isDark ? Colors.black : Colors.white;
    final contentColor = isDark ? Colors.white : Colors.black;
    final glassColor = isDark 
        ? const Color(0xFF1A1A1A).withValues(alpha: 0.8) 
        : Colors.white.withValues(alpha: 0.8);
    final borderColor = isDark 
        ? Colors.white.withValues(alpha: 0.1) 
        : Colors.black.withValues(alpha: 0.05);
    final activeColor = theme.colorScheme.primary; // Your Unit Blue

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Stack(
        children: [
          // 2. MAIN CONTENT (Split View)
          Padding(
            padding: const EdgeInsets.only(top: 120), // Space for floating header
            child: Row(
              children: [
                // LEFT SIDEBAR (Clean Categories)
                Container(
                  width: 90,
                  decoration: BoxDecoration(
                    border: Border(right: BorderSide(color: borderColor, width: 0.5)),
                  ),
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedCategoryIndex == index;
                      return GestureDetector(
                        onTap: () => setState(() => selectedCategoryIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: isSelected ? activeColor : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Text(
                            categories[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                              color: isSelected ? activeColor : contentColor.withValues(alpha: 0.4),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // RIGHT RESULTS AREA
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      children: [
                        _buildFeaturedServiceCard(context, theme, activeColor),
                        const SizedBox(height: 25),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 250,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                          ),
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return const ProviderCard(
                              name: "Jackson",
                              job: "Electrician",
                            );
                          },
                        ),
                        const SizedBox(height: 100), // Space for Bottom Nav
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. FLOATING GLASS HEADER (Matches Search/Profile Top Bar)
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: glassColor,
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_new, size: 18, color: contentColor),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: TextField(
                          style: TextStyle(color: contentColor, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            hintText: widget.query ?? "Search services...",
                            hintStyle: TextStyle(color: contentColor.withValues(alpha: 0.3), fontSize: 15),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.tune_rounded, color: activeColor), // Unit Blue for filter
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (_) => const FilterSheet(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedServiceCard(BuildContext context, ThemeData theme, Color activeColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: activeColor, // Featured card keeps primary brand color
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: activeColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "FEATURED SERVICE",
            style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          const Text(
            "Professional Repair",
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: activeColor,
                elevation: 0,
                shape: const StadiumBorder(),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => GetServiceScreen(query: widget.query)),
              ),
              child: const Text("Get Now", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}