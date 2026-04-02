import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../../../core/constants/pusher_constants.dart';
import '../../../../../core/models/service_model.dart';
import '../../../../../core/provider/pusher_provider.dart';
import '../service_repository_provider.dart';
import 'service_local_storage_provider.dart';

final serviceNotifierProvider =
AsyncNotifierProvider<ServiceNotifier, List<Service>>(
  ServiceNotifier.new,
);

class ServiceNotifier extends AsyncNotifier<List<Service>> {
  static const String _serviceChannelName = PusherChannels.services;
  static const String _serviceEventName = PusherEvents.serviceChanged;

  static const String _categoryChannelName = PusherChannels.categories;
  static const String _categoryEventName = PusherEvents.categoryChanged;

  static const String _typeChannelName = PusherChannels.types;
  static const String _typeEventName = PusherEvents.typeChanged;

  Timer? _refreshDebounce;
  bool _disposed = false;

  @override
  Future<List<Service>> build() async {
    ref.onDispose(() {
      _disposed = true;
      _refreshDebounce?.cancel();
    });

    await _startPusherListener();

    final cached = await _loadLocalServices();

    if (cached.isNotEmpty) {
      Future.microtask(_refreshFromApiSilently);
      return cached;
    }

    return _refreshFromApi();
  }

  Future<List<Service>> _fetchServices({int page = 1}) async {
    final repository = ref.read(serviceRepositoryProvider);
    return repository.getServices(page: page);
  }

  Future<List<Service>> _loadLocalServices() async {
    final local = ref.read(serviceLocalStorageProvider);
    return local.getServices();
  }

  Future<void> _saveLocalServices(List<Service> services) async {
    final local = ref.read(serviceLocalStorageProvider);
    await local.saveServices(services);
  }

  Future<List<Service>> _refreshFromApi({int page = 1}) async {
    final services = await _fetchServices(page: page);
    await _saveLocalServices(services);
    return services;
  }

  Future<void> _refreshFromApiSilently({int page = 1}) async {
    try {
      final services = await _fetchServices(page: page);
      await _saveLocalServices(services);

      if (!_disposed) {
        state = AsyncData(services);
      }
    } catch (e, stackTrace) {
      debugPrint('Silent refresh error: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _scheduleSilentRefresh() {
    _refreshDebounce?.cancel();
    _refreshDebounce = Timer(const Duration(milliseconds: 400), () async {
      if (!_disposed) {
        await _refreshFromApiSilently();
      }
    });
  }

  Future<void> _startPusherListener() async {
    final pusher = ref.read(pusherServiceProvider);

    void onEvent(PusherEvent event) {
      if (_disposed) return;

      final isServiceEvent = event.channelName == _serviceChannelName &&
          event.eventName == _serviceEventName;

      final isCategoryEvent = event.channelName == _categoryChannelName &&
          event.eventName == _categoryEventName;

      final isTypeEvent = event.channelName == _typeChannelName &&
          event.eventName == _typeEventName;

      if (!isServiceEvent && !isCategoryEvent && !isTypeEvent) {
        return;
      }

      if (isCategoryEvent || isTypeEvent) {
        _scheduleSilentRefresh();
        return;
      }

      try {
        final rawData = event.data;

        if (rawData == null || rawData.isEmpty) {
          _scheduleSilentRefresh();
          return;
        }

        final decoded = jsonDecode(rawData) as Map<String, dynamic>;
        final action = decoded['action']?.toString();
        final serviceJson = decoded['service'] as Map<String, dynamic>?;
        final rawServiceId =
            decoded['serviceId'] ?? decoded['service_id'] ?? decoded['id'];

        switch (action) {
          case PusherActions.created:
          case PusherActions.restored:
            if (serviceJson != null) {
              _syncCreatedService(Service.fromJson(serviceJson));
            } else {
              _scheduleSilentRefresh();
            }
            break;

          case PusherActions.updated:
            if (serviceJson != null) {
              _syncUpdatedService(Service.fromJson(serviceJson));
            } else {
              _scheduleSilentRefresh();
            }
            break;

          case PusherActions.deleted:
          case PusherActions.forceDeleted:
            final id = rawServiceId is int
                ? rawServiceId
                : int.tryParse(rawServiceId.toString());

            if (id != null) {
              _removeService(id);
            } else {
              _scheduleSilentRefresh();
            }
            break;

          default:
            _scheduleSilentRefresh();
        }
      } catch (e, stackTrace) {
        debugPrint('Pusher parse error: $e');
        debugPrintStack(stackTrace: stackTrace);
        _scheduleSilentRefresh();
      }
    }

    ref.onDispose(() => pusher.removeListener(onEvent));

    await pusher.init(onEvent: onEvent);
  }

  bool _isActive(Service service) {
    return service.status == 'active';
  }

  Future<void> _saveCurrentStateLocally(List<Service> services) async {
    state = AsyncData(services);
    await _saveLocalServices(services);
  }

  void _syncCreatedService(Service created) {
    final current = state.valueOrNull;
    if (current == null || _disposed) return;

    if (!_isActive(created)) return;

    final exists = current.any((s) => s.id == created.id);

    final updated = exists
        ? current.map((s) => s.id == created.id ? created : s).toList()
        : [created, ...current];

    _saveCurrentStateLocally(updated);
  }

  void _syncUpdatedService(Service updated) {
    final current = state.valueOrNull;
    if (current == null || _disposed) return;

    final exists = current.any((s) => s.id == updated.id);
    final isActive = _isActive(updated);

    List<Service> next;

    if (isActive) {
      next = exists
          ? current.map((s) => s.id == updated.id ? updated : s).toList()
          : [updated, ...current];
    } else {
      next = current.where((s) => s.id != updated.id).toList();
    }

    _saveCurrentStateLocally(next);
  }

  void _removeService(int id) {
    final current = state.valueOrNull;
    if (current == null || _disposed) return;

    final updated = current.where((s) => s.id != id).toList();
    _saveCurrentStateLocally(updated);
  }

  Future<void> refreshServices({int page = 1}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _refreshFromApi(page: page));
  }
}