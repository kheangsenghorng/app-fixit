import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/api_endpoints.dart';
import '../../../../../core/network/dio_provider.dart';
import '../model/service_search_response_model.dart';

class ServiceRepository {
  final Dio dio;

  ServiceRepository({required this.dio});

  Future<ServiceSearchResponse> searchActiveServices(String search) async {
    final response = await dio.get(
      ApiEndpoints.searchActiveServices,
      queryParameters: {'search': search},
    );
    return ServiceSearchResponse.fromJson(
      Map<String, dynamic>.from(response.data),
    );
  }
}

final serviceRepositoryProviderSearch = Provider<ServiceRepository>((ref) {
  final dio = ref.read(dioProvider);
  return ServiceRepository(dio: dio);
});