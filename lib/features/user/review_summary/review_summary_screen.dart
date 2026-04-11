import 'package:fixit/features/user/review_summary/widgets/coupon_section.dart';
import 'package:fixit/features/user/review_summary/widgets/floating_action_section.dart';
import 'package:fixit/features/user/review_summary/widgets/info_badge.dart';
import 'package:fixit/features/user/review_summary/widgets/note_section.dart';
import 'package:fixit/features/user/review_summary/widgets/section_header_label.dart';
import 'package:fixit/features/user/review_summary/widgets/show_success_booking_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/coupon_model.dart';
import '../../auth/presentation/providers/auth_controller.dart';
import 'data/providers/service_booking_provider.dart';
import 'data/repositories/coupon_repository.dart';

import 'data/repositories/coupon_usage_repository.dart';
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

    final String address = args['address']?.toString() ?? "No address provided";
    final String providerName = args['name']?.toString() ?? "Emily Jani";
    final String dateText = args['date']?.toString() ?? "Dec 23, 2024";
    final String timeText = args['time']?.toString() ?? "10:00 AM";
    final String houseNo = args['house_no']?.toString() ?? "1-99";
    final String street = args['street']?.toString() ?? "st3";

    final String categoryName =
        providerData['category']?['name']?.toString() ?? '';

    final double basePrice =
        double.tryParse(providerData['base_price']?.toString() ?? '0') ?? 0;

    discountedPrice ??= basePrice;

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
                  totalPrice: '\$${(discountedPrice ?? basePrice).toStringAsFixed(2)}/H',
                  originalPrice: appliedCoupon != null
                      ? '\$${basePrice.toStringAsFixed(2)}/H'
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
              totalPrice: discountedPrice ?? basePrice,
              originalPrice: appliedCoupon != null ? basePrice : null,
              onPressed: () async {
                try {
                  await ref.read(authControllerProvider.notifier).loadProfile();
                  final auth = ref.read(authControllerProvider).valueOrNull;
                  final int? userId = auth?.user?.id;

                  if (userId == null) {
                    debugPrint('User ID is null');
                    return;
                  }

                  final bookingRepository = ref.read(serviceBookingRepositoryProvider);

                  await bookingRepository.createBooking(
                    userId: userId,
                    serviceId: providerData['id'] ?? 0,
                    houseNo: houseNo,
                    street: street,
                    bookingDate: dateText,
                    bookingHours: timeText,
                    address: address,
                    latitude: latitude ?? 0,
                    longitude: longitude ?? 0,
                    mapUrl: mapUrl ?? '',
                    note: noteController.text.trim(),
                  );

                  // Save coupon usage after booking success
                  if (appliedCoupon != null) {
                    await ref.read(
                      couponUsageRepositoryProvider,
                    ).createCouponUsage(
                      couponId: appliedCoupon!.id,
                      userId: userId,
                      timesUsed: 1,
                    );
                  }

                  if (context.mounted) {
                    showSuccessBookingDialog(
                      context,
                      time: timeText,
                    );
                  }
                } catch (e) {
                  debugPrint('Booking Error: $e');

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}