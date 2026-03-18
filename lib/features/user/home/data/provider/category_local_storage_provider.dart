import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/storage/category_local_storage.dart';



final categoryLocalStorageProvider = Provider<CategoryLocalStorage>((ref) {
  return CategoryLocalStorage();
});