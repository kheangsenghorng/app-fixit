import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/api_endpoints.dart';
import '../../../../../core/models/service_model.dart';
import '../../../../../core/network/dio_provider.dart';

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return ServiceRepository(ref.read(dioProvider));
});

class ServiceRepository {
  final Dio dio;

  ServiceRepository(this.dio);

  Future<List<Service>> getServices({int page = 1}) async {
    final res = await dio.get(
      ApiEndpoints.activeServices,
      queryParameters: {
        'page': page,
      },
    );

    final List data = res.data['data'];

    return data
        .map((e) => Service.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}