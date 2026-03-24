import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/storage/type_local_storage.dart';


final typeLocalStorageProvider = Provider<TypeLocalStorage>((ref) {
  return TypeLocalStorage();
});