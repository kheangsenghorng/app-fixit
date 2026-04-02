import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/models/service_model.dart';

class ServiceLocalStorage {
  static const _key = 'cached_services';

  Future<void> saveServices(List<Service> services) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, Service.encodeList(services));
  }

  Future<List<Service>> getServices() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    if (raw == null || raw.isEmpty) {
      return [];
    }

    return Service.decodeList(raw);
  }

  Future<void> clearServices() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}