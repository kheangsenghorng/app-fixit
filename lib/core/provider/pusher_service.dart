import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherService {
  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();
  bool _initialized = false;

  // ✅ Store multiple listeners instead of one
  final List<void Function(PusherEvent event)> _listeners = [];

  Future<void> init({
    required void Function(PusherEvent event) onEvent,
  }) async {
    // ✅ Always register the new listener
    if (!_listeners.contains(onEvent)) {
      _listeners.add(onEvent);
    }

    if (_initialized) return;

    await _pusher.init(
      apiKey: dotenv.env['PUSHER_API_KEY'] ?? '',
      cluster: dotenv.env['PUSHER_CLUSTER'] ?? 'ap1',
      // ✅ Fan out to all registered listeners
      onEvent: (event) {
        for (final listener in List.of(_listeners)) {
          listener(event);
        }
      },
      onConnectionStateChange: (currentState, previousState) {},
      onError: (message, code, error) {},
    );

    await _pusher.subscribe(channelName: 'categories');
    await _pusher.subscribe(channelName: 'types');
    await _pusher.connect();

    _initialized = true;
  }

  // ✅ Call this when a listener is disposed
  void removeListener(void Function(PusherEvent event) onEvent) {
    _listeners.remove(onEvent);
  }

  Future<void> disconnect() async {
    await _pusher.disconnect();
    _listeners.clear();
    _initialized = false;
  }
}