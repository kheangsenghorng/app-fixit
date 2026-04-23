import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/types_service.dart';

import '../../../../../core/network/dio_provider.dart';
import '../../../../../core/models/type_model.dart';
import '../../../../../core/storage/type_local_storage.dart';
import '../model/types_state.dart';
import 'type_local_storage_provider.dart';

final typeServiceProvider = Provider<TypeService>((ref) {
  final dio = ref.read(dioProvider);
  return TypeService(dio);
});

final typeProvider = StateNotifierProvider<TypeNotifier, TypeState>((ref) {
  final service = ref.read(typeServiceProvider);
  final localStorage = ref.read(typeLocalStorageProvider);
  return TypeNotifier(service, localStorage);
});

class TypeNotifier extends StateNotifier<TypeState> {
  final TypeService _service;
  final TypeLocalStorage _localStorage;

  TypeNotifier(this._service, this._localStorage) : super(const TypeState());

  Future<void> loadInitialTypes() async {
    if (state.isInitialized) return;

    final cached = await _localStorage.getTypes();

    if (cached.isNotEmpty) {
      state = state.copyWith(
        types: cached,
        isInitialized: true,
        page: 1,
        hasMore: true,
      );

      await refreshSilently();
      return;
    }

    await fetchActiveTypes();
  }

  Future<void> fetchActiveTypes({bool loadMore = false}) async {
    try {
      if (loadMore) {
        if (!state.hasMore || state.isLoadingMore) return;

        state = state.copyWith(isLoadingMore: true, error: null);

        final nextPage = state.page + 1;
        final newTypes = await _service.getActiveTypes(page: nextPage);
        final updatedTypes = [...state.types, ...newTypes];

        state = state.copyWith(
          types: updatedTypes,
          page: nextPage,
          hasMore: newTypes.isNotEmpty,
          isLoadingMore: false,
          isInitialized: true,
        );

        await _localStorage.saveTypes(updatedTypes);
      } else {
        state = state.copyWith(
          isLoading: true,
          isLoadingMore: false,
          page: 1,
          error: null,
        );

        final types = await _service.getActiveTypes(page: 1);

        state = state.copyWith(
          types: types,
          isLoading: false,
          page: 1,
          hasMore: types.isNotEmpty,
          isInitialized: true,
        );

        await _localStorage.saveTypes(types);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    await fetchActiveTypes();
  }

  Future<void> addType(TypeModel type) async {
    final exists = state.types.any((item) => item.id == type.id);

    final updatedTypes = exists
        ? state.types.map((item) => item.id == type.id ? type : item).toList()
        : [type, ...state.types];

    state = state.copyWith(types: updatedTypes, error: null);
    await _localStorage.saveTypes(updatedTypes);
  }

  Future<void> updateType(TypeModel type) async {
    final exists = state.types.any((item) => item.id == type.id);

    final updatedTypes = exists
        ? state.types.map((item) => item.id == type.id ? type : item).toList()
        : [type, ...state.types];

    state = state.copyWith(types: updatedTypes, error: null);
    await _localStorage.saveTypes(updatedTypes);
  }

  Future<void> removeType(int id) async {
    final updatedTypes = state.types.where((item) => item.id != id).toList();

    state = state.copyWith(types: updatedTypes, error: null);
    await _localStorage.saveTypes(updatedTypes);
  }

  /// Use this when receiving realtime update event.
  /// If active => add/update
  /// If inactive => remove
  Future<void> syncTypeFromEvent(TypeModel type) async {
    // Change this condition based on your model
    // Example:
    // final isActive = type.status == 1;
    // or final isActive = type.status == 'active';
    final isActive = type.status == 'active';

    if (isActive) {
      await updateType(type);
    } else {
      await removeType(type.id);
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<void> refreshSilently() async {
    try {
      final types = await _service.getActiveTypes(page: 1);

      state = state.copyWith(
        types: types,
        page: 1,
        hasMore: types.isNotEmpty,
        isInitialized: true,
        error: null,
      );

      await _localStorage.saveTypes(types);
    } catch (_) {}
  }
}