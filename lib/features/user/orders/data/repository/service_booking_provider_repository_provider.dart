import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/network/dio_provider.dart';
import '../repository/service_booking_provider_repository.dart';

final serviceBookingProviderRepositoryProvider =
Provider<ServiceBookingProviderRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ServiceBookingProviderRepository(dio);
});