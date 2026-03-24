import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/models/type_model.dart';

class TypeLocalStorage {
  static const _key = 'cached_active_types';

  Future<List<TypeModel>> getTypes() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    if (raw == null || raw.isEmpty) return [];

    final List decoded = jsonDecode(raw);
    return decoded
        .map((e) => TypeModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> saveTypes(List<TypeModel> types) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(types.map((e) => e.toJson()).toList());
    await prefs.setString(_key, raw);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}