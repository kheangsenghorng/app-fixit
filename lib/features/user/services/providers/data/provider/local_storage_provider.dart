class LocalStorageKeys {
  static const cachedActiveTypes = 'cached_active_types';
  static const cachedCategories = 'cached_categories';

  static String cachedActiveTypesByCategory(int categoryId) {
    return 'cached_active_types_$categoryId';
  }
}