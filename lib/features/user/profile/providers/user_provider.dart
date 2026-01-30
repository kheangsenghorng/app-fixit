import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/user_model.dart';
import '../providers/user_repository_provider.dart';

class UserNotifier extends AsyncNotifier<UserModel> {
  @override
  Future<UserModel> build() async {
    final profile = await ref.read(userRepositoryProvider).getProfile();
    return profile.user;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final profile = await ref.read(userRepositoryProvider).getProfile();
      return profile.user;
    });
  }
}

final userProvider =
AsyncNotifierProvider<UserNotifier, UserModel>(UserNotifier.new);
