import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/models/type_model.dart';
import '../repository/type_repository_provider.dart';


final typesByCategoryProvider =
FutureProvider.family<List<TypeModel>, int>((ref, categoryId) async {
  final repository = ref.read(typeRepositoryProvider);
  return repository.getTypesByCategory(categoryId);
});