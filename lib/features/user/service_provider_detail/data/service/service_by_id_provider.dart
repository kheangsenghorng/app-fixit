import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/models/service_model.dart';
import '../provider/sevice_repository_provider.dart';



final serviceByIdProvider =
FutureProvider.family<Service, int>((ref, serviceId) async {
  final repository = ref.read(serviceRepositoryProviderByID);
  return repository.getServiceById(serviceId);
});