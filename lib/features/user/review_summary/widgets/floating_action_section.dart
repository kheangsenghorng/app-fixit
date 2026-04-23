import 'package:flutter/material.dart';

class FloatingActionSection extends StatelessWidget {
  final String time;
  final double totalPrice;
  final double? originalPrice;
  final Future<void> Function(String method) onPaymentSelected;

  const FloatingActionSection({
    super.key,
    required this.time,
    required this.totalPrice,
    this.originalPrice,
    required this.onPaymentSelected,
  });

  Future<void> _showPaymentMethodSheet(BuildContext context) {
    final theme = Theme.of(context);

    return showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (sheetContext) {
        bool isLoading = false;
        String? selectedMethod;

        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> handleTap(String method) async {
              if (isLoading) return;
              setModalState(() {
                isLoading = true;
                selectedMethod = method;
              });
              try {
                await onPaymentSelected(method);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              } finally {
                if (context.mounted) {
                  setModalState(() {
                    isLoading = false;
                    selectedMethod = null;
                  });
                }
              }
            }

            return PopScope(
              canPop: !isLoading,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Payment Method',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Choose your preferred way to pay',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 24),
                      _PaymentMethodTile(
                        image: 'assets/images/khqr-5.png',
                        title: 'KHQR Payment',
                        subtitle: 'Scan to pay with any bank app',
                        isLoading: isLoading && selectedMethod == 'khqr',
                        isDisabled: isLoading,
                        onTap: () => handleTap('khqr'),
                        iconBgColor: const Color(0xFFE51D28), // Bakong Red
                      ),
                      const Divider(height: 1, indent: 64),
                      _PaymentMethodTile(
                        image: 'assets/images/bakong.png',
                        title: 'Pay via Bakong App',
                        subtitle: 'Direct payment from Bakong wallet',
                        isLoading: isLoading && selectedMethod == 'bakong',
                        isDisabled: isLoading,
                        onTap: () => handleTap('bakong'),
                        iconBgColor: const Color(0xFFE51D28),
                      ),
                      const Divider(height: 1, indent: 64),
                      _PaymentMethodTile(
                        icon: Icons.account_balance_wallet_outlined,
                        title: 'Cash Payment',
                        subtitle: 'Pay after service is done',
                        isLoading: isLoading && selectedMethod == 'cash',
                        isDisabled: isLoading,
                        onTap: () => handleTap('cash'),
                        iconBgColor: Colors.grey[100]!,
                        iconColor: Colors.black87,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 34),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Estimated Total',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (originalPrice != null)
                    Text(
                      '\$${originalPrice!.toStringAsFixed(2)}',
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  Text(
                    '\$${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 0,
              ),
              onPressed: () => _showPaymentMethodSheet(context),
              child: const Text(
                'Confirm Booking',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final IconData? icon;
  final String? image;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isLoading;
  final bool isDisabled;
  final Color iconBgColor;
  final Color? iconColor;

  const _PaymentMethodTile({
    this.icon,
    this.image,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isLoading = false,
    this.isDisabled = false,
    required this.iconBgColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDisabled && !isLoading ? 0.5 : 1,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              // --- ROUND IMAGE/ICON CONTAINER ---
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconBgColor,
                ),
                child: ClipOval(
                  child: isLoading
                      ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : image != null
                      ? Image.asset(
                    image!,
                    fit: BoxFit.cover,
                  )
                      : Icon(
                    icon,
                    color: iconColor ?? Colors.black,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // --- TEXT SECTION ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLoading)
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xFFD1D1D1),
                ),
            ],
          ),
        ),
      ),
    );
  }
}