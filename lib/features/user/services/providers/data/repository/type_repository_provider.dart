import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/constants/api_endpoints.dart';
import '../../../../../../core/network/dio_provider.dart';
import '../../../../../../core/models/type_model.dart';
import '../model/type_response_model.dart';

final typeRepositoryProvider = Provider<TypeRepository>((ref) {
  return TypeRepository(ref.read(dioProvider));
});

class TypeRepository {
  final Dio dio;

  TypeRepository(this.dio);

  Future<List<TypeModel>> getTypesByCategory(int categoryId) async {
    final res = await dio.get(ApiEndpoints.activeByCategory(categoryId));

    final response = TypeResponse.fromJson(
      Map<String, dynamic>.from(res.data),
    );

    return response.data;
  }
}