import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fixit/core/network/dio_provider.dart';
import '../repositories/service_booking_repository.dart';

final serviceBookingRepositoryProvider =
Provider<ServiceBookingRepository>((ref) {
  final dio = ref.read(dioProvider);
  return ServiceBookingRepository(dio);
});