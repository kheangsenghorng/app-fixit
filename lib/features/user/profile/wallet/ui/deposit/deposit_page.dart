import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/wallet_provider.dart';


class DepositPage extends ConsumerStatefulWidget {
  final int walletId;
  final int userId;

  const DepositPage({
    super.key,
    required this.walletId,
    required this.userId,
  });

  @override
  ConsumerState<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends ConsumerState<DepositPage> {
  final TextEditingController _amountController =
  TextEditingController(text: "0.00");

  int _selectedMethodIndex = 0;

  final List<String> _quickAmounts = ["5", "10", "20", "50", "100"];

  final List<Map<String, dynamic>> _methods = [
    {
      "title": "Linked Bank Account",
      "subtitle": "ABA Bank ....4291",
      "icon": Icons.account_balance_outlined,
      "method": "aba",
    },
    {
      "title": "Bakong KHQR",
      "subtitle": "Scan or Pay with ID",
      "icon": Icons.qr_code_scanner_rounded,
      "method": "bakong",
    },
    {
      "title": "Cash",
      "subtitle": "Cash top-up",
      "icon": Icons.payments_outlined,
      "method": "cash",
    },
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _confirmDeposit() async {
    HapticFeedback.mediumImpact();

    final amount = double.tryParse(_amountController.text.trim()) ?? 0;

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter valid amount"),
        ),
      );
      return;
    }

    final selectedMethod = _methods[_selectedMethodIndex];
    final method = selectedMethod['method'] as String;

    final success = await ref.read(walletTopUpProvider.notifier).topUpWallet(
      walletId: widget.walletId,
      userId: widget.userId,
      amount: amount,
      method: method,
      transactionRef: method.toUpperCase(),
      externalTransactionId:
      "${method.toUpperCase()}-${DateTime.now().millisecondsSinceEpoch}",
      description: "Top up wallet by ${selectedMethod['title']}",
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Wallet topped up successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } else {
      final error = ref.read(walletTopUpProvider).error;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error?.toString() ?? "Failed to top up wallet"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final topUpState = ref.watch(walletTopUpProvider);
    final isLoading = topUpState.isLoading;

    const Color primaryBlue = Color(0xFF1976D2);
    const Color bgGrey = Color(0xFFF8F9FB);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Deposit",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: isLoading ? null : () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            const Text(
              "Deposit Funds",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Add money to your Fixit wallet securely.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.6),
              ),
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "AMOUNT (USD)",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.4),
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "\$",
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          enabled: !isLoading,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}'),
                            ),
                          ],
                          onChanged: (val) => setState(() {}),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF2E3A59),
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "0.00",
                            hintStyle: TextStyle(
                              color: Color(0xFFB0B4C1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Text(
              "QUICK SELECT",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.4),
                letterSpacing: 1.1,
              ),
            ),

            const SizedBox(height: 15),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: _quickAmounts.map((amt) {
                  final isSelected =
                      _amountController.text == amt ||
                          _amountController.text == "$amt.00";

                  return GestureDetector(
                    onTap: isLoading
                        ? null
                        : () {
                      setState(() {
                        _amountController.text = amt;
                      });
                      HapticFeedback.selectionClick();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? primaryBlue : bgGrey,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                          isSelected ? primaryBlue : Colors.transparent,
                        ),
                      ),
                      child: Text(
                        "\$$amt",
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 35),

            const Text(
              "Payment Method",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 10),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _methods.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final isSelected = _selectedMethodIndex == index;
                final method = _methods[index];

                return GestureDetector(
                  onTap: isLoading
                      ? null
                      : () {
                    setState(() => _selectedMethodIndex = index);
                    HapticFeedback.lightImpact();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : bgGrey,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                        isSelected ? primaryBlue : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? bgGrey : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            method['icon'],
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                method['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                method['subtitle'],
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: primaryBlue,
                            size: 24,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: isLoading ? null : _confirmDeposit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  disabledBackgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: isLoading
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
                    : const Text(
                  "Confirm Deposit",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}