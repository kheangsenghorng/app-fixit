import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/models/category_model.dart';

class CategoryLocalStorage {
  static const _key = 'cached_categories';

  Future<void> saveCategories(List<Category> categories) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, Category.encodeList(categories));
  }

  Future<List<Category>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    if (raw == null || raw.isEmpty) {
      return [];
    }

    return Category.decodeList(raw);
  }

  Future<void> clearCategories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}