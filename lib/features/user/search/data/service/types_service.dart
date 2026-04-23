import 'package:dio/dio.dart';

import '../../../../../core/constants/api_endpoints.dart';
import '../../../../../core/models/type_model.dart';

class TypeService {
  final Dio dio;

  TypeService(this.dio);
  Future<List<TypeModel>> getActiveTypes({int page = 1, String? search}) async {
    final response = await dio.get(
      ApiEndpoints.active,
      queryParameters: {
        "page": page,
        "per_page": 10,
        if (search != null && search.isNotEmpty) "search": search,
      },
    );

    final data = response.data['data'];

    return (data as List)
        .map((e) => TypeModel.fromJson(e))
        .toList();
  }

}