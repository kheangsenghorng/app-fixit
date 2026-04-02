import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../../../core/storage/service_local_storage.dart';


final serviceLocalStorageProvider = Provider<ServiceLocalStorage>((ref) {
  return ServiceLocalStorage();
});