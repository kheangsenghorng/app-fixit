import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../../../core/models/type_model.dart';
import '../../../../../core/provider/pusher_provider.dart';
import '../../features/user/search/data/providers/types_provider.dart';

final typeListenerProvider = Provider<void>((ref) {
  final pusher = ref.read(pusherServiceProvider);

  void onEvent(PusherEvent event) async {
    final notifier = ref.read(typeProvider.notifier);

    if (event.channelName == 'types' && event.eventName == 'type.changed') {
      if (event.data.isEmpty) return;

      final data = jsonDecode(event.data) as Map<String, dynamic>;
      final action = data['action']?.toString();
      final typeJson = data['type'];
      final typeId = data['typeId'];

      switch (action) {
        case 'created':
        case 'restored':
        case 'updated':
          if (typeJson is Map<String, dynamic>) {
            await notifier.syncTypeFromEvent(TypeModel.fromJson(typeJson));
          }
          return;
        case 'deleted':
        case 'force_deleted':
          final id = typeId is int
              ? typeId
              : int.tryParse(typeId?.toString() ?? '');
          if (id != null) await notifier.removeType(id);
          return;
      }
    }

    if (event.channelName == 'categories' &&
        event.eventName == 'category.changed') {
      await notifier.refreshSilently();
    }
  }

  // ✅ Remove listener when provider is disposed
  ref.onDispose(() => pusher.removeListener(onEvent));

  pusher.init(onEvent: onEvent);
});