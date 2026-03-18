import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/api_endpoints.dart';
import '../../../../../core/models/category_model.dart';
import '../../../../../core/network/dio_provider.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(ref.read(dioProvider));
});

class CategoryRepository {
  final Dio dio;

  CategoryRepository(this.dio);

  Future<List<Category>> getCategories({int page = 1}) async {
    final res = await dio.get(
      ApiEndpoints.activeCategory,
      queryParameters: {
        'page': page,
      },
    );

    final List data = res.data['data'];

    return data
        .map((e) => Category.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}