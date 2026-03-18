import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pusher_service.dart';

final pusherServiceProvider = Provider<PusherService>((ref) {
  final service = PusherService();

  ref.onDispose(() {
    service.disconnect();
  });

  return service;
});