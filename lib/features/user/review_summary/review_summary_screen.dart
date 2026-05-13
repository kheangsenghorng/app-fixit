import 'package:fixit/features/user/review_summary/widgets/coupon_section.dart';
import 'package:fixit/features/user/review_summary/widgets/floating_action_section.dart';
import 'package:fixit/features/user/review_summary/widgets/info_badge.dart';
import 'package:fixit/features/user/review_summary/widgets/note_section.dart';
import 'package:fixit/features/user/review_summary/widgets/payment_qr_dialog.dart';
import 'package:fixit/features/user/review_summary/widgets/section_header_label.dart';
import 'package:fixit/features/user/review_summary/widgets/show_success_booking_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/coupon_model.dart';
import '../../auth/presentation/providers/auth_controller.dart';
import '../profile/wallet/data/providers/wallet_provider.dart';
import 'data/model/payment_request_model.dart';
import 'data/providers/service_booking_provider.dart';
import 'data/providers/wallet_transaction_repository_provider.dart';
import 'data/repositories/coupon_repository.dart';

import 'data/repositories/coupon_usage_repository.dart';
import 'data/repositories/payment_repository.dart';
import 'widgets/booking_details_card.dart';
import 'widgets/price_summary_section.dart';
import 'widgets/provider_profile_card.dart';

class ReviewSummaryScreen extends ConsumerStatefulWidget {
  const ReviewSummaryScreen({super.key});

  @override
  ConsumerState<ReviewSummaryScreen> createState() =>
      _ReviewSummaryScreenState();
}

class _ReviewSummaryScreenState extends ConsumerState<ReviewSummaryScreen> {
  late final TextEditingController noteController;
  late final TextEditingController couponController;

  bool _isInitialized = false;

  CouponData? appliedCoupon;
  double? discountedPrice;

  @override
  void didChangeDependencies() {
    if (_isInitialized) return;
    super.didChangeDependencies();

    final Object? rawArgs = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic> args =
    rawArgs is Map<String, dynamic> ? rawArgs : {};

    noteController = TextEditingController(
      text: args['note']?.toString() ?? '',
    );

    couponController = TextEditingController(
      text: args['coupon']?.toString() ?? '',
    );
    _isInitialized = true;
  }

  @override
  void dispose() {
    noteController.dispose();
    couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Object? rawArgs = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic> args =
    rawArgs is Map<String, dynamic> ? rawArgs : {};

    final Map<String, dynamic> providerData =
    args['providerData'] is Map<String, dynamic>
        ? args['providerData']
        : {};
    final Map<String, dynamic> selectedPackage =
    args['selected_package'] is Map<String, dynamic>
        ? args['selected_package']
        : {};

    final String address = args['address']?.toString() ?? "No address provided";

    final int? addressId = args['address_id'] is int
        ? args['address_id'] as int
        : int.tryParse(args['address_id']?.toString() ?? '');


    final int? packageId = selectedPackage['id'] is int
        ? selectedPackage['id'] as int
        : int.tryParse(selectedPackage['id']?.toString() ?? '');


    final String providerName = args['name']?.toString() ?? "Emily Jani";
    final String dateText = args['date']?.toString() ?? "Dec 23, 2024";
    final String timeText = args['time']?.toString() ?? "10:00 AM";
    final String houseNo = args['house_no']?.toString() ?? "1-99";
    final String street = args['street']?.toString() ?? "st3";

    final String categoryName =
        providerData['category']?['name']?.toString() ?? '';

    final double basePrice =
        double.tryParse(selectedPackage['price']?.toString() ?? '0') ?? 0;

    final String packageTitle =
        selectedPackage['title']?.toString() ?? 'Selected Package';

    final String packageDuration =
        selectedPackage['duration_hours']?.toString() ?? '';

    final String packageWorkers =
        selectedPackage['workers_count']?.toString() ?? '';

    if (appliedCoupon == null) {
      discountedPrice = basePrice;
    }

    final double displayPrice = discountedPrice ?? basePrice;

    final String typeName = providerData['type'] is Map
        ? providerData['type']['name']?.toString() ?? ''
        : '';

    final double? latitude = args['latitude'] != null
        ? double.tryParse(args['latitude'].toString())
        : null;

    final double? longitude = args['longitude'] != null
        ? double.tryParse(args['longitude'].toString())
        : null;

    final String? mapUrl = args['map_url']?.toString();

    final dynamic rawImage = args['image'];
    final String providerImage = rawImage is Map
        ? rawImage['url']?.toString() ?? ''
        : rawImage?.toString() ?? '';

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: colorScheme.onSurface,
              size: 18,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          "Review Summary",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeaderLabel(
                  text: "Professional Detail",
                ),
                ProviderInfoCard(
                  name: providerName,
                  image: providerImage,
                ),

                const SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selected Package',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        packageTitle,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          InfoBadge(
                            icon: Icons.attach_money,
                            label: '\$${basePrice.toStringAsFixed(2)}',
                          ),
                          if (packageDuration.isNotEmpty)
                            InfoBadge(
                              icon: Icons.schedule,
                              label: '$packageDuration hours',
                            ),
                          if (packageWorkers.isNotEmpty)
                            InfoBadge(
                              icon: Icons.groups_outlined,
                              label: '$packageWorkers workers',
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (categoryName.isNotEmpty || typeName.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (categoryName.isNotEmpty)
                        InfoBadge(
                          icon: Icons.category_outlined,
                          label: categoryName,
                        ),
                      if (typeName.isNotEmpty)
                        InfoBadge(
                          icon: Icons.layers_outlined,
                          label: typeName,
                        ),
                      const InfoBadge(
                        icon: Icons.star,
                        label: "4.9 Rating",
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 32),
                const SectionHeaderLabel(
                  text: "Schedule & Location",
                ),
                BookingDetailsCard(
                  address: address,
                  date: dateText,
                  time: timeText,
                ),
                const SizedBox(height: 32),
                const SectionHeaderLabel(
                  text: "Add Note",
                ),
                NoteSection(
                  controller: noteController,
                ),
                const SizedBox(height: 32),
                const SectionHeaderLabel(
                  text: "Coupon Code",
                ),
                CouponSection(
                  controller: couponController,
                  onApply: () async {
                    final couponCode = couponController.text.trim();

                    if (couponCode.isEmpty) return;

                    try {
                      final int ownerId = providerData['owner']?['id'] ?? 0;

                      final couponResponse = await ref.read(
                        couponRepositoryProvider,
                      ).getCouponByUniqueId(
                        couponCode,
                        ownerId
                      );

                      final coupon = couponResponse.data;

                      double newPrice = basePrice;

                      if (coupon.discountType == 'percent') {
                        final percent =
                            double.tryParse(coupon.discountValue) ?? 0;
                        newPrice = basePrice - (basePrice * percent / 100);
                      } else if (coupon.discountType == 'fixed') {
                        final fixed =
                            double.tryParse(coupon.discountValue) ?? 0;
                        newPrice = basePrice - fixed;
                      }

                      if (newPrice < 0) {
                        newPrice = 0;
                      }

                      setState(() {
                        appliedCoupon = coupon;
                        discountedPrice = newPrice;
                      });

                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Coupon applied successfully'),
                        ),
                      );
                    } catch (e) {
                      debugPrint('Coupon Error: $e');

                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 32),
                const SectionHeaderLabel(
                  text: "Payment Overview",
                ),
                PriceSummaryCard(
                  packageTitle: packageTitle,
                  totalPrice: '\$${displayPrice.toStringAsFixed(2)}',
                  originalPrice: appliedCoupon != null
                      ? '\$${basePrice.toStringAsFixed(2)}'
                      : null,
                  couponText: appliedCoupon != null
                      ? appliedCoupon!.discountType == 'percent'
                      ? '${appliedCoupon!.discountValue}% off'
                      : '\$${appliedCoupon!.discountValue} off'
                      : null,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FloatingActionSection(
              time: timeText,
              totalPrice: displayPrice,
              originalPrice: appliedCoupon != null ? basePrice : null,
              onPaymentSelected: (method) async {
                try {
                  await ref.read(authControllerProvider.notifier).loadProfile();

                  final auth = ref.read(authControllerProvider).valueOrNull;
                  final int? userId = auth?.user?.id;

                  if (userId == null) {
                    throw Exception('User not found');
                  }

                  final paymentRepository = ref.read(paymentRepositoryProvider);
                  final bookingRepository = ref.read(serviceBookingRepositoryProvider);
                  final walletTransactionRepository =
                  ref.read(walletTransactionRepositoryProvider);

                  final totalAmount = discountedPrice ?? basePrice;

                  final discountAmount = appliedCoupon != null
                      ? basePrice - totalAmount
                      : 0.0;

                  String transactionId;
                  String paymentStatus;

                  if (method == 'khqr' || method == 'bakong') {
                    final paymentResponse = await paymentRepository.generatePayment(
                      PaymentRequest(
                        amount: totalAmount,
                        billNumber: 'BOOKING-${DateTime.now().millisecondsSinceEpoch}',
                        mobileNumber: '012345678',
                        storeLabel: 'FiXIT',
                        terminalLabel: 'App',
                        purposeOfTransaction: 'Service booking payment',
                        expirationTimestamp: DateTime.now()
                            .add(const Duration(minutes: 30))
                            .millisecondsSinceEpoch,
                      ),
                    );

                    final md5 = paymentResponse.data.md5;
                    final deeplink = paymentResponse.data.deeplink?.shortLink;
                    final imageBase64 = paymentResponse.data.image?.imageBase64;

                    if (md5 == null || md5.isEmpty) {
                      throw Exception('Payment md5 not found');
                    }

                    if (imageBase64 == null || imageBase64.isEmpty) {
                      throw Exception('QR image not found');
                    }

                    if (!context.mounted) return;
                    Navigator.of(context).pop();

                    await Future.delayed(const Duration(milliseconds: 150));

                    if (!context.mounted) return;

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

                    if (externalRef == null || externalRef.isEmpty) {
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Payment not successful'),
                        ),
                      );
                      return;
                    }

                    transactionId = externalRef;
                    paymentStatus = 'paid';
                  } else if (method == 'wallet') {
                    if (!context.mounted) return;
                    Navigator.of(context).pop();

                    transactionId = 'WALLET-${DateTime.now().millisecondsSinceEpoch}';
                    paymentStatus = 'paid';
                  } else {
                    if (!context.mounted) return;
                    Navigator.of(context).pop();

                    transactionId = 'CASH-${DateTime.now().millisecondsSinceEpoch}';
                    paymentStatus = 'pending';
                  }

                  if (addressId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select an address')),
                    );
                    return;
                  }

                  if (packageId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a package')),
                    );
                    return;
                  }

                  final bookingResponse = await bookingRepository.createBooking(
                    userId: userId,
                    serviceId: providerData['id'] ?? 0,
                    servicePackageId: packageId,
                    houseNo: houseNo,
                    street: street,
                    bookingDate: dateText,
                    bookingHours: timeText,
                    addressId: addressId,
                    latitude: latitude ?? 0,
                    longitude: longitude ?? 0,
                    mapUrl: mapUrl ?? '',
                    note: noteController.text.trim(),
                  );

                  final bookingId = bookingResponse.data['data']?['id'];

                  if (bookingId == null) {
                    throw Exception('Booking ID not found');
                  }

                  final int ownerId =
                      providerData['owner']?['id'] ??
                          providerData['user_id'] ??
                          providerData['owner_id'] ??
                          0;

                  if (ownerId == 0) {
                    throw Exception('Owner ID not found');
                  }

                  final paymentResponse = await paymentRepository.payment(
                    PaymentRequest(
                      userId: userId,
                      ownerId: ownerId,
                      serviceBookingId: bookingId,
                      couponsId: appliedCoupon?.id,
                      transactionId: transactionId,
                      originalAmount: basePrice,
                      discountAmount: discountAmount,
                      finalAmount: totalAmount,
                      method: method,
                      status: paymentStatus,
                    ),
                  );

                  final int paymentId = paymentResponse.data.id;


                  if (method == 'wallet') {
                    final walletRepository = ref.read(walletRepositoryProvider);

                    final walletResponse = await walletRepository.getWalletByUserId(userId);

                    final wallet = walletResponse.data;

                    if (wallet == null) {
                      throw Exception('Wallet not found');
                    }

                    if (!wallet.isActive || wallet.status != 'active') {
                      throw Exception('Wallet is not active');
                    }

                    if (wallet.balance < totalAmount) {
                      throw Exception('Insufficient wallet balance');
                    }

                    await walletTransactionRepository.createWalletTransaction(
                      walletId: wallet.walletId,
                      userId: userId,
                      paymentId: paymentId,
                      serviceBookingId: bookingId,
                      type: 'debit',
                      method: 'wallet',
                      transactionRef: 'WALLET-$bookingId',
                      amount: totalAmount,
                      description: 'Wallet payment for service booking #$bookingId',
                    );
                  }
                  if (appliedCoupon != null) {
                    await ref.read(couponUsageRepositoryProvider).createCouponUsage(
                      couponId: appliedCoupon!.id,
                      userId: userId,
                      timesUsed: 1,
                    );
                  }

                  if (!context.mounted) return;

                  await Future.delayed(const Duration(milliseconds: 100));

                  if (!context.mounted) return;

                  await showSuccessBookingDialog(
                    context,
                    time: timeText,
                  );
                } catch (e) {
                  debugPrint('Booking Error: $e');

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString().replaceFirst('Exception: ', '')),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}