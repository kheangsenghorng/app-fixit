import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../ service/types_service.dart';
import '../../../../../core/network/dio_provider.dart';
import '../model/types_state.dart';


/// Service Provider
final typeServiceProvider = Provider<TypeService>((ref) {
  final dio = ref.read(dioProvider);
  return TypeService(dio);
});

/// StateNotifier Provider
final typeProvider =
StateNotifierProvider<TypeNotifier, TypeState>((ref) {
  final service = ref.read(typeServiceProvider);
  return TypeNotifier(service);
});

class TypeNotifier extends StateNotifier<TypeState> {
  final TypeService _service;

  TypeNotifier(this._service) : super(const TypeState());

  /// Fetch Active Types
  Future<void> fetchActiveTypes({bool loadMore = false}) async {
    try {
      if (loadMore) {
        if (!state.hasMore || state.isLoadingMore) return;

        state = state.copyWith(isLoadingMore: true);

        final nextPage = state.page + 1;

        final newTypes = await _service.getActiveTypes(page: nextPage);

        state = state.copyWith(
          types: [...state.types, ...newTypes],
          page: nextPage,
          hasMore: newTypes.isNotEmpty,
          isLoadingMore: false,
        );
      } else {
        state = state.copyWith(isLoading: true, page: 1);

        final types = await _service.getActiveTypes(page: 1);

        state = state.copyWith(
          types: types,
          isLoading: false,
          hasMore: types.isNotEmpty,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  /// Refresh types
  Future<void> refresh() async {
    await fetchActiveTypes();
  }



  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}