import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/network/dio_provider.dart';
import '../service/category_repository.dart';


final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return CategoryRepository(dio: dio);
});