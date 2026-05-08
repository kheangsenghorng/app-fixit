import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final scaffoldBg = isDark ? Colors.black : Colors.white;
    final contentColor = isDark ? Colors.white : Colors.black;
    final cardBg = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final borderColor = isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05);

    // MOCK DATA for Wallet
    const balance = "1,250.00";
    const currency = "USD";

    // MOCK DATA for Transactions
    final List<Map<String, dynamic>> transactions = [
      {
        "type": "deposit",
        "amount": 500.00,
        "title": "Wallet Top-up",
        "date": "May 05, 2024",
        "status": "completed"
      },
      {
        "type": "withdrawal",
        "amount": 120.00,
        "title": "Service Payment",
        "date": "May 04, 2024",
        "status": "completed"
      },
      {
        "type": "withdrawal",
        "amount": 45.00,
        "title": "AC Repair",
        "date": "May 02, 2024",
        "status": "pending"
      },
    ];

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 130, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. BALANCE CARD
                _buildSectionHeader("Current Balance", contentColor),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: _cardDecoration(cardBg, isDark),
                  child: Column(
                    children: [
                      Text("\$$balance",
                          style: TextStyle(color: contentColor, fontSize: 42, fontWeight: FontWeight.w900)),
                      Text(currency, style: TextStyle(color: contentColor.withOpacity(0.5))),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 2. TRANSACTION HISTORY SECTION
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionHeader("Recent Transactions", contentColor),
                    Text("See All", style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: _cardDecoration(cardBg, isDark),
                  child: Column(
                    children: transactions.isEmpty
                        ? [const Padding(padding: EdgeInsets.all(40), child: Text("No transactions yet"))]
                        : List.generate(transactions.length, (index) {
                      final tx = transactions[index];
                      return _transactionTile(
                        tx: tx,
                        contentColor: contentColor,
                        isLast: index == transactions.length - 1,
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 40),

                // 3. QUICK ACTIONS
                Row(
                  children: [
                    Expanded(child: _actionButton("Deposit", Icons.add_rounded, Colors.blue)),
                    const SizedBox(width: 15),
                    Expanded(child: _actionButton("Withdraw", Icons.arrow_outward_rounded, contentColor)),
                  ],
                )
              ],
            ),
          ),

          // GLASS HEADER
          _buildGlassHeader(contentColor, isDark),
        ],
      ),
    );
  }

  // --- UI HELPERS ---

  Widget _transactionTile({
    required Map<String, dynamic> tx,
    required Color contentColor,
    required bool isLast
  }) {
    final isDeposit = tx['type'] == 'deposit';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon based on type
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDeposit ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isDeposit ? Icons.south_west_rounded : Icons.north_east_rounded,
                  color: isDeposit ? Colors.green : Colors.red,
                  size: 18,
                ),
              ),
              const SizedBox(width: 15),
              // Title & Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tx['title'], style: TextStyle(color: contentColor, fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(tx['date'], style: TextStyle(color: contentColor.withOpacity(0.4), fontSize: 11)),
                  ],
                ),
              ),
              // Amount & Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${isDeposit ? '+' : '-'}\$${tx['amount']}",
                    style: TextStyle(
                      color: isDeposit ? Colors.green : contentColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                  if (tx['status'] == 'pending')
                    const Text("PENDING", style: TextStyle(color: Colors.orange, fontSize: 9, fontWeight: FontWeight.bold))
                ],
              ),
            ],
          ),
        ),
        if (!isLast) Divider(color: contentColor.withOpacity(0.05), height: 1, indent: 70),
      ],
    );
  }

  BoxDecoration _cardDecoration(Color bg, bool isDark) {
    return BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
    );
  }

  Widget _actionButton(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Text(title.toUpperCase(), style: TextStyle(color: color.withOpacity(0.4), fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.2));
  }

  Widget _buildGlassHeader(Color contentColor, bool isDark) {
    return Positioned(
      top: 50, left: 16, right: 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(35),
              border: Border.all(color: contentColor.withOpacity(0.1)),
            ),
            child: Center(
              child: Text("Wallet & Activity", style: TextStyle(color: contentColor, fontWeight: FontWeight.w900, fontSize: 18)),
            ),
          ),
        ),
      ),
    );
  }
}