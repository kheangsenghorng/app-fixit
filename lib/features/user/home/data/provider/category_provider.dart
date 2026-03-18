import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../../../../core/models/category_model.dart';
import '../../../../../core/provider/pusher_provider.dart';
import '../category_repository.dart';
import 'category_local_storage_provider.dart';

final categoryNotifierProvider =
AsyncNotifierProvider.autoDispose<CategoryNotifier, List<Category>>(
  CategoryNotifier.new,
);

class CategoryNotifier extends AutoDisposeAsyncNotifier<List<Category>> {
  bool _isListening = false;

  @override
  Future<List<Category>> build() async {
    ref.onDispose(() {
      final pusher = ref.read(pusherServiceProvider);
      unawaited(pusher.disconnect());
    });

    await _startPusherListener();

    final cached = await _loadLocalCategories();

    if (cached.isNotEmpty) {
      Future.microtask(() async {
        await _refreshFromApiSilently();
      });
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
      state = AsyncData(categories);
    } catch (_) {
      // Keep cached state if API fails
    }
  }

  Future<void> _startPusherListener() async {
    if (_isListening) return;
    _isListening = true;

    final pusher = ref.read(pusherServiceProvider);

    await pusher.init(
      onEvent: (PusherEvent event) async {

        if (event.channelName == 'categories' &&
            (event.eventName == 'category.updated' ||
                event.eventName == 'category.created' ||
                event.eventName == 'category.deleted')) {

          await _refreshFromApiSilently();
        }
      },
    );
  }

  Future<void> refreshCategories({int page = 1}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _refreshFromApi(page: page));
  }
}