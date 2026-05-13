import 'dart:ui';

import 'package:fixit/features/user/profile/wallet/ui/deposit/deposit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'data/model/wallet_transaction_model.dart';
import 'data/providers/wallet_provider.dart';

class WalletScreen extends ConsumerStatefulWidget {
  final int userId;

  const WalletScreen({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    final walletAsync = ref.watch(walletByUserIdProvider(widget.userId));

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final scaffoldBg = isDark ? Colors.black : Colors.white;
    final contentColor = isDark ? Colors.white : Colors.black;
    final cardBg = isDark ? const Color(0xFF1A1A1A) : Colors.white;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Stack(
        children: [
          walletAsync.when(
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            error: (error, stackTrace) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: contentColor),
                  ),
                ),
              );
            },
            data: (wallet) {
              if (wallet == null) {
                return Center(
                  child: Text(
                    "No wallet found",
                    style: TextStyle(color: contentColor),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(walletByUserIdProvider(widget.userId));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 130, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader("Current Balance", contentColor),
                      const SizedBox(height: 15),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(30),
                        decoration: _cardDecoration(cardBg, isDark),
                        child: Column(
                          children: [
                            Text(
                              "\$${wallet.balance.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: contentColor,
                                fontSize: 42,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              wallet.currency,
                              style: TextStyle(
                                color: contentColor.withOpacity(0.5),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              wallet.status.toUpperCase(),
                              style: TextStyle(
                                color: wallet.isActive
                                    ? Colors.green
                                    : Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      Row(
                        children: [
                          Expanded(
                            child: _actionButton(
                              "Deposit",
                              Icons.add_rounded,
                              Colors.blue,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DepositPage(
                                      walletId: wallet.walletId,
                                      userId: wallet.userId,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSectionHeader(
                            "Recent Transactions",
                            contentColor,
                          ),
                          Text(
                            "See All",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Container(
                        decoration: _cardDecoration(cardBg, isDark),
                        child: wallet.transactions.isEmpty
                            ? Padding(
                          padding: const EdgeInsets.all(40),
                          child: Center(
                            child: Text(
                              "No transactions yet",
                              style: TextStyle(color: contentColor),
                            ),
                          ),
                        )
                            : Column(
                          children: List.generate(
                            wallet.transactions.length,
                                (index) {
                              final tx = wallet.transactions[index];

                              return _transactionTile(
                                tx: tx,
                                contentColor: contentColor,
                                isLast: index ==
                                    wallet.transactions.length - 1,
                              );
                            },
                          ),
                        ),
                      ),


                    ],
                  ),
                ),
              );
            },
          ),

          _buildGlassHeader(contentColor, isDark),
        ],
      ),
    );
  }

  Widget _transactionTile({
    required WalletTransaction tx,
    required Color contentColor,
    required bool isLast,
  }) {
    final isCredit = tx.type == 'credit';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isCredit
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCredit
                      ? Icons.south_west_rounded
                      : Icons.north_east_rounded,
                  color: isCredit ? Colors.green : Colors.red,
                  size: 18,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx.description ?? tx.type,
                      style: TextStyle(
                        color: contentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      _formatDate(tx.createdAt),
                      style: TextStyle(
                        color: contentColor.withOpacity(0.4),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${isCredit ? '+' : '-'}\$${tx.amount.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: isCredit ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    tx.method ?? 'wallet',
                    style: TextStyle(
                      color: contentColor.withOpacity(0.4),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            color: contentColor.withOpacity(0.05),
            height: 1,
            indent: 70,
          ),
      ],
    );
  }

  BoxDecoration _cardDecoration(Color bg, bool isDark) {
    return BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(28),
      border: Border.all(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.05),
      ),
    );
  }

  Widget _actionButton(
      String label,
      IconData icon,
      Color color, {
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: color.withOpacity(0.4),
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildGlassHeader(Color contentColor, bool isDark) {
    return Positioned(
      top: 50,
      left: 16,
      right: 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(35),
              border: Border.all(
                color: contentColor.withOpacity(0.1),
              ),
            ),
            child: Center(
              child: Text(
                "Wallet & Activity",
                style: TextStyle(
                  color: contentColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '';

    try {
      final parsedDate = DateTime.parse(date);
      return "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return date;
    }
  }
}