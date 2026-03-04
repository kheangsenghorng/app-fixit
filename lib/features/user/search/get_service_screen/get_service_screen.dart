import 'dart:ui';
import 'package:flutter/material.dart';

class GetServiceScreen extends StatelessWidget {
  final String? query;
  const GetServiceScreen({super.key, this.query});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = theme.colorScheme.primary;

    // 1. BLACK & WHITE MONOCHROME LOGIC
    final scaffoldBg = isDark ? Colors.black : Colors.white;
    final contentColor = isDark ? Colors.white : Colors.black;
    final cardBg = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final glassColor = isDark 
        ? const Color(0xFF1A1A1A).withValues(alpha: 0.8) 
        : Colors.white.withValues(alpha: 0.8);
    final borderColor = isDark 
        ? Colors.white.withValues(alpha: 0.1) 
        : Colors.black.withValues(alpha: 0.05);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Stack(
        children: [
          // 2. SCROLLABLE CONTENT
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 130, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TOP SUMMARY CARD (Solid monochrome style)
                _buildSummaryCard(context, cardBg, borderColor, contentColor, activeColor),
                
                const SizedBox(height: 40),
                Text(
                  "Choose your service",
                  style: TextStyle(
                    color: contentColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w900, // Premium Heavy weight
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 20),

                // SERVICE LIST ITEMS (Solid B&W cards)
                _serviceItem(context, "Wiring Installation", Icons.cable, Colors.green, cardBg, borderColor, contentColor),
                _serviceItem(context, "Electrical Repairs", Icons.build, Colors.blue, cardBg, borderColor, contentColor),
                _serviceItem(context, "Indoor Lighting", Icons.lightbulb, Colors.purple, cardBg, borderColor, contentColor),
                _serviceItem(context, "Fixture Installation", Icons.fluorescent, Colors.pink, cardBg, borderColor, contentColor),
                _serviceItem(context, "Panel Upgrades", Icons.developer_board, Colors.amber, cardBg, borderColor, contentColor),
                
                const SizedBox(height: 20),
              ],
            ),
          ),

          // 3. FLOATING GLASS HEADER (Monochrome)
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
                      const SizedBox(width: 8),
                      Text(
                        query ?? "Service Details",
                        style: TextStyle(
                          color: contentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
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

  Widget _buildSummaryCard(BuildContext context, Color bg, Color border, Color txtColor, Color active) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20)
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    query ?? "Service", 
                    style: TextStyle(color: txtColor, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5)
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, color: active, size: 20),
                      Text(" 4.8 ", style: TextStyle(fontWeight: FontWeight.bold, color: active)),
                      Text("(76 Reviews)", style: TextStyle(color: txtColor.withValues(alpha: 0.4), fontSize: 12)),
                    ],
                  ),
                ],
              ),
              Container(
                height: 60, width: 60,
                decoration: BoxDecoration(
                  color: active.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.electrical_services, size: 32, color: active),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Divider(color: border, height: 1),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("\$20/Hr", style: TextStyle(fontWeight: FontWeight.w900, color: active, fontSize: 20)),
              Row(
                children: [
                  _timeBadge(context, "7:00 AM", active),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text("-", style: TextStyle(color: Colors.grey))),
                  _timeBadge(context, "10:00 PM", active),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _timeBadge(BuildContext context, String time, Color active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(time, style: TextStyle(color: active, fontWeight: FontWeight.bold, fontSize: 11)),
    );
  }

  Widget _serviceItem(BuildContext context, String title, IconData icon, Color accentColor, Color bg, Color border, Color txtColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: TextStyle(color: txtColor, fontWeight: FontWeight.w600, fontSize: 15))),
          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: txtColor.withValues(alpha: 0.2)),
        ],
      ),
    );
  }
}