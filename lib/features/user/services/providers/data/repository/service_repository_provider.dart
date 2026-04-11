import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/constants/api_endpoints.dart';
import '../../../../../../core/network/dio_provider.dart';
import '../../../../../../core/models/service_model.dart';
import '../model/service_response_model.dart';

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return ServiceRepository(ref.read(dioProvider));
});

class ServiceRepository {
  final Dio dio;

  ServiceRepository(this.dio);

  Future<List<Service>> getServiceByType(int typeId) async {
    final res = await dio.get(
      ApiEndpoints.activeServicesByType(typeId),
    );

    final response = ServiceResponse.fromJson(
      Map<String, dynamic>.from(res.data as Map),
    );

    return response.data;
  }
}