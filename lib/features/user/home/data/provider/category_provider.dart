import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../../../core/models/category_model.dart';
import '../../../../../core/provider/pusher_provider.dart';
import '../category_repository.dart';
import 'category_local_storage_provider.dart';

final categoryNotifierProvider =
AsyncNotifierProvider<CategoryNotifier, List<Category>>(
  CategoryNotifier.new,
);

class CategoryNotifier extends AsyncNotifier<List<Category>> {
  static const String _channelName = 'categories';
  static const String _eventName = 'category.changed';

  Timer? _refreshDebounce;
  bool _disposed = false;

  @override
  Future<List<Category>> build() async {
    ref.onDispose(() {
      _disposed = true;
      _refreshDebounce?.cancel();
    });

    await _startPusherListener();

    final cached = await _loadLocalCategories();

    if (cached.isNotEmpty) {
      Future.microtask(() => _refreshFromApiSilently());
      return cached;
    }

    return _refreshFromApi();
  }

  Future<List<Category>> _fetchCategories({int page = 1}) async {
    final repository = ref.read(categoryRepositoryProvider);
    return repository.getCategories(page: page);
  }

  Future<List<Category>> _loadLocalCategories() async {
    final local = ref.read(categoryLocalStorageProvider);
    return local.getCategories();
  }

  Future<void> _saveLocalCategories(List<Category> categories) async {
    final local = ref.read(categoryLocalStorageProvider);
    await local.saveCategories(categories);
  }

  Future<List<Category>> _refreshFromApi({int page = 1}) async {
    final categories = await _fetchCategories(page: page);
    await _saveLocalCategories(categories);
    return categories;
  }

  Future<void> _refreshFromApiSilently({int page = 1}) async {
    try {
      final categories = await _fetchCategories(page: page);
      await _saveLocalCategories(categories);

      if (!_disposed) {
        state = AsyncData(categories);
      }
    } catch (_) {}
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

      if (event.channelName != _channelName ||
          event.eventName != _eventName) {
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
        final categoryJson = decoded['category'] as Map<String, dynamic>?;

        switch (action) {
          case 'created':
          case 'restored':
            if (categoryJson != null) {
              _syncCreatedCategory(Category.fromJson(categoryJson));
            } else {
              _scheduleSilentRefresh();
            }
            break;

          case 'updated':
            if (categoryJson != null) {
              _syncUpdatedCategory(Category.fromJson(categoryJson));
            } else {
              _scheduleSilentRefresh();
            }
            break;

          case 'deleted':
          case 'force_deleted':
            if (categoryJson != null) {
              final rawId = categoryJson['id'];
              final id = rawId is int ? rawId : int.tryParse(rawId.toString());

              if (id != null) {
                _removeCategory(id);
              } else {
                _scheduleSilentRefresh();
              }
            } else {
              _scheduleSilentRefresh();
            }
            break;

          default:
            _scheduleSilentRefresh();
        }
      } catch (_) {
        _scheduleSilentRefresh();
      }
    }

    ref.onDispose(() => pusher.removeListener(onEvent));

    await pusher.init(onEvent: onEvent);
  }

  bool _isActive(Category category) {
    return category.status == 'active';
  }

  Future<void> _saveCurrentStateLocally(List<Category> categories) async {
    state = AsyncData(categories);
    await _saveLocalCategories(categories);
  }

  void _syncCreatedCategory(Category created) {
    final current = state.valueOrNull;
    if (current == null || _disposed) return;

    if (!_isActive(created)) {
      return;
    }

    final exists = current.any((c) => c.id == created.id);

    final updated = exists
        ? current.map((c) => c.id == created.id ? created : c).toList()
        : [created, ...current];

    _saveCurrentStateLocally(updated);
  }

  void _syncUpdatedCategory(Category updated) {
    final current = state.valueOrNull;
    if (current == null || _disposed) return;

    final exists = current.any((c) => c.id == updated.id);
    final isActive = _isActive(updated);

    List<Category> next;

    if (isActive) {
      next = exists
          ? current.map((c) => c.id == updated.id ? updated : c).toList()
          : [updated, ...current];
    } else {
      next = current.where((c) => c.id != updated.id).toList();
    }

    _saveCurrentStateLocally(next);
  }

  void _removeCategory(int id) {
    final current = state.valueOrNull;
    if (current == null || _disposed) return;

    final updated = current.where((c) => c.id != id).toList();
    _saveCurrentStateLocally(updated);
  }

  Future<void> refreshCategories({int page = 1}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _refreshFromApi(page: page));
  }
}