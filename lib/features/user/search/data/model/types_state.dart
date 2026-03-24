import '../../../../../core/models/type_model.dart';

class TypeState {
  final bool isLoading;
  final bool isLoadingMore;
  final bool isInitialized;
  final List<TypeModel> types;
  final int page;
  final bool hasMore;
  final String? error;

  const TypeState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isInitialized = false,
    this.types = const [],
    this.page = 1,
    this.hasMore = true,
    this.error,
  });

  TypeState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? isInitialized,
    List<TypeModel>? types,
    int? page,
    bool? hasMore,
    String? error,
  }) {
    return TypeState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isInitialized: isInitialized ?? this.isInitialized,
      types: types ?? this.types,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      error: error,
    );
  }
}