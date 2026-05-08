import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/api_endpoints.dart';
import '../../../../../core/models/service_model.dart';
import '../../../../../core/network/dio_provider.dart';

final serviceRepositoryProviderByID = Provider<ServiceRepository>((ref) {
  return ServiceRepository(ref.read(dioProvider));
});

class ServiceRepository {
  final Dio dio;

  ServiceRepository(this.dio);

  Future<Service> getServiceById(int serviceId) async {
    try {
      final res = await dio.get(
        ApiEndpoints.service(serviceId),
      );

      final data = res.data['data'];

      if (data == null) {
        throw Exception('Service data not found');
      }

      return Service.fromJson(
        Map<String, dynamic>.from(data),
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message']?.toString() ??
            e.message ??
            'Failed to load service',
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}