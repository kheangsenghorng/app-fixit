import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/network/dio_provider.dart';
import 'service_booking_repository.dart';

final serviceBookingRepositoryProvider =
Provider<ServiceBookingRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ServiceBookingRepository(dio);
});