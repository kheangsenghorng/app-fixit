import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/booking_providers_response.dart';
import '../repository/service_booking_provider_repository_provider.dart';


final bookingProvidersByBookingIdProvider =
FutureProvider.family<BookingProvidersResponse, int>((ref, bookingId) async {
  final repository = ref.watch(serviceBookingProviderRepositoryProvider);
  return repository.getByBookingId(bookingId);
});