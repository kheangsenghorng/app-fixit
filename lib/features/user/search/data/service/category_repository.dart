import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/api_endpoints.dart';
import '../../../../../core/models/category_model.dart';
import '../../../../../core/network/dio_provider.dart';

class CategoryRepository {
  final Dio dio;

  CategoryRepository({required this.dio});

  Future<List<Category>> getActiveCategories() async {
    try {
      final response = await dio.get(ApiEndpoints.activeCategory);
      final body = response.data;

      if (body is List) {
        return body
            .map((e) => Category.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }

      if (body is Map<String, dynamic> && body['data'] is List) {
        return (body['data'] as List)
            .map((e) => Category.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }

      throw Exception('Unexpected response format');
    } on DioException catch (e) {
      throw Exception(
        'Failed to load active categories: ${e.response?.statusCode ?? e.message}',
      );
    }
  }
}

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return CategoryRepository(dio: dio);
});

final activeCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getActiveCategories();
});