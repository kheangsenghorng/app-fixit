import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Maintain your existing imports
import '../../../../review_summary/data/model/payment_request_model.dart';
import '../../../../review_summary/data/repositories/payment_repository.dart';
import '../../../../review_summary/widgets/payment_qr_dialog.dart';
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
  final TextEditingController _amountController = TextEditingController(text: "0.00");
  String _selectedMethodKey = 'khqr';
  String? _loadingMethodKey;

  bool get _isProcessing => _loadingMethodKey != null;
  final List<String> _quickAmounts = ["5", "10", "20", "50", "100"];

  // Color Palette
  static const Color primaryColor = Color(0xFF1A1A1A); // Modern Dark
  static const Color accentColor = Color(0xFF0066FF); // Brand Blue
  static const Color surfaceColor = Color(0xFFF7F9FC);
  static const Color cardColor = Colors.white;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _confirmDeposit(String method) async {
    if (_isProcessing) return;
    HapticFeedback.mediumImpact();

    final amount = double.tryParse(_amountController.text.trim()) ?? 0;

    if (amount <= 0) {
      _showSnackBar("Please enter a valid amount", Colors.orange);
      return;
    }

    setState(() {
      _selectedMethodKey = method;
      _loadingMethodKey = method;
    });

    try {
      final paymentRepository = ref.read(paymentRepositoryProvider);
      String externalTransactionId;

      if (method == 'khqr' || method == 'bakong') {
        final paymentResponse = await paymentRepository.generatePayment(
          PaymentRequest(
            amount: amount,
            billNumber: 'WALLET-${DateTime.now().millisecondsSinceEpoch}',
            mobileNumber: '012345678', // Replace with dynamic if needed
            storeLabel: 'FiXIT',
            terminalLabel: 'Wallet',
            purposeOfTransaction: 'Wallet top up',
            expirationTimestamp: DateTime.now().add(const Duration(minutes: 30)).millisecondsSinceEpoch,
          ),
        );

        final md5 = paymentResponse.data.md5;
        final deeplink = paymentResponse.data.deeplink?.shortLink;
        final imageBase64 = paymentResponse.data.image?.imageBase64;

        if (md5 == null || imageBase64 == null) throw Exception('Payment generation failed');

        if (!mounted) return;
        setState(() => _loadingMethodKey = null);

        final String? externalRef = await Navigator.of(context).push<String>(
          MaterialPageRoute(
            builder: (_) => PaymentQrPage(
              base64Image: imageBase64,
              deeplink: method == 'bakong' ? deeplink : null,
              isBakongOnly: method == 'bakong',
              onCheckPayment: () => paymentRepository.checkMd5(md5),
            ),
          ),
        );

        if (externalRef == null) throw Exception('Payment cancelled');
        externalTransactionId = externalRef;

        if (mounted) setState(() => _loadingMethodKey = method);
      } else {
        externalTransactionId = "CASH-${DateTime.now().millisecondsSinceEpoch}";
      }

      final success = await ref.read(walletTopUpProvider.notifier).topUpWallet(
        walletId: widget.walletId,
        userId: widget.userId,
        amount: amount,
        method: method,
        transactionRef: 'DEP-${DateTime.now().millisecondsSinceEpoch}',
        externalTransactionId: externalTransactionId,
        description: "Top up wallet via ${method.toUpperCase()}",
      );

      if (!mounted) return;

      if (success) {
        _showSnackBar("Wallet topped up successfully", Colors.green);
        Navigator.pop(context);
      } else {
        throw Exception(ref.read(walletTopUpProvider).error ?? "Failed to top up");
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar(e.toString().replaceFirst('Exception: ', ''), Colors.red);
    } finally {
      if (mounted) setState(() => _loadingMethodKey = null);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(walletTopUpProvider).isLoading || _isProcessing;

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: primaryColor),
          onPressed: isLoading ? null : () => Navigator.pop(context),
        ),
        title: const Text(
          "Top Up Wallet",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.w800, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Input Card
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "Enter Amount",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[500],
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          "\$",
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryColor),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IntrinsicWidth(
                        child: TextField(
                          controller: _amountController,
                          enabled: !isLoading,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: primaryColor),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "0.00",
                            hintStyle: TextStyle(color: Color(0xFFE0E0E0)),
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Quick Select
            const Text(
              "QUICK SELECT",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1.2),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _quickAmounts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final amt = _quickAmounts[index];
                  final isSelected = _amountController.text == amt || _amountController.text == "$amt.00";
                  return GestureDetector(
                    onTap: isLoading
                        ? null
                        : () {
                      setState(() => _amountController.text = amt);
                      HapticFeedback.lightImpact();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: isSelected ? accentColor : cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? accentColor : Colors.transparent,
                        ),
                        boxShadow: isSelected
                            ? [BoxShadow(color: accentColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          "\$$amt",
                          style: TextStyle(
                            color: isSelected ? Colors.white : primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 40),

            // Payment Methods Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Payment Method',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: primaryColor),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Icon(Icons.shield_outlined, size: 14, color: Colors.green[700]),
                      const SizedBox(width: 4),
                      Text("Secure", style: TextStyle(fontSize: 12, color: Colors.green[700], fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),

            _buildMethodCard(
              title: 'KHQR Payment',
              subtitle: 'Scan with any Cambodian Bank app',
              image: 'assets/images/khqr-5.png',
              methodKey: 'khqr',
              isLoading: isLoading,
            ),
            const SizedBox(height: 12),
            _buildMethodCard(
              title: 'Bakong App',
              subtitle: 'Direct transfer from Bakong',
              image: 'assets/images/bakong.png',
              methodKey: 'bakong',
              isLoading: isLoading,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodCard({
    required String title,
    required String subtitle,
    required String image,
    required String methodKey,
    required bool isLoading,
  }) {
    final isThisLoading = _loadingMethodKey == methodKey;
    final isSelected = _selectedMethodKey == methodKey;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? accentColor.withOpacity(0.5) : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: isLoading ? null : () => _confirmDeposit(methodKey),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(image, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: primaryColor),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                if (isThisLoading)
                  const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: accentColor))
                else
                  Icon(
                    isSelected ? Icons.check_circle_rounded : Icons.arrow_forward_ios_rounded,
                    color: isSelected ? accentColor : Colors.grey[300],
                    size: isSelected ? 26 : 18,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}