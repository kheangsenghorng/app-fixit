import 'package:fixit/features/user/search/data/service/service_repository_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/models/service_model.dart';

final searchServicesProvider =
FutureProvider.family<List<Service>, String>((ref, query) async {
  final repo = ref.read(serviceRepositoryProviderSearch);
  final response = await repo.searchActiveServices(query);
  return response.data;
});