import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherService {
  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();

  bool _initialized = false;

  Future<void> init({
    required void Function(PusherEvent event) onEvent,
  }) async {
    if (_initialized) return;

    await _pusher.init(
      apiKey: dotenv.env['PUSHER_API_KEY'] ?? '',
      cluster: dotenv.env['PUSHER_CLUSTER'] ?? 'ap1',
      onEvent: onEvent,
      onConnectionStateChange: (currentState, previousState) {},
      onError: (message, code, error) {},
    );

    await _pusher.subscribe(channelName: 'categories');
    await _pusher.connect();

    _initialized = true;
  }

  Future<void> disconnect() async {
    await _pusher.disconnect();
    _initialized = false;
  }
}