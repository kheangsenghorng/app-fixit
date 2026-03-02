import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/models/user_model.dart';
import '../data/edit_profile_repository.dart';

/// Provider
final editProfileProvider =
StateNotifierProvider<EditProfileNotifier, AsyncValue<UserModel?>>((ref) {
  final repo = ref.read(editProfileRepositoryProvider);
  return EditProfileNotifier(repo);
});

class EditProfileNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final EditProfileRepository repository;

  EditProfileNotifier(this.repository)
      : super(const AsyncValue.data(null));

  Future<void> loadProfile(int userId) async {
    state = const AsyncLoading();
    try {
      final user = await repository.getProfile(userId);
      state = AsyncData(user);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateProfile({
    required int userId,
    required String name,
    String? phone,
    String? email,
  }) async {
    final previousState = state;

    // Keep current data while loading
    state = const AsyncLoading<UserModel?>()
        .copyWithPrevious(previousState);

    try {
      final updatedUser = await repository.updateProfile(
        userId: userId,
        name: name,
        phone: phone,
        email: email,
      );

      state = AsyncData(updatedUser ?? previousState.value);
    } catch (e, st) {
      state = AsyncError<UserModel?>(e, st)
          .copyWithPrevious(previousState);
    }
  }
  Future<void> updateAvatar({
    required int userId,
    required String filePath,
  }) async {
    final previousState = state;

    state = const AsyncLoading<UserModel?>()
        .copyWithPrevious(previousState);

    try {
      final updatedUser = await repository.updateAvatar(
        userId: userId,
        filePath: filePath,
      );

      state = AsyncData(updatedUser ?? previousState.value);
    } on DioException catch (e, st) {
      if (e.response?.statusCode == 422) {
        // Get validation message from backend
        final message = e.response?.data['message'] ??
            'Validation failed';

        state = AsyncError<UserModel?>(message, st)
            .copyWithPrevious(previousState);
      } else {
        state = AsyncError<UserModel?>(e, st)
            .copyWithPrevious(previousState);
      }
    } catch (e, st) {
      state = AsyncError<UserModel?>(e, st)
          .copyWithPrevious(previousState);
    }
  }


}
