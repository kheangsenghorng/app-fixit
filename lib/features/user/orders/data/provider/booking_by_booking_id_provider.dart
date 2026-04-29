import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/service_booking_response.dart';
import '../repository/service_booking_repository_provider.dart';

final bookingByBookingIdProvider =
FutureProvider.family<ServiceBookingResponse, int>((ref, bookingId) async {
  final repository = ref.watch(serviceBookingRepositoryProvider);
  return repository.getByBookingId(bookingId);
});