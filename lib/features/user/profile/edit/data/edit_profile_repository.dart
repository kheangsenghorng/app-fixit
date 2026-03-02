import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/api_endpoints.dart';
import '../../../../../core/models/user_model.dart';
import '../../../../../core/network/dio_provider.dart';
import '../../model/profile_response_model.dart';

/// Repository provider
final editProfileRepositoryProvider =
Provider<EditProfileRepository>((ref) {
  final dio = ref.read(dioProvider);
  return EditProfileRepository(dio);
});

class EditProfileRepository {
  final Dio dio;

  EditProfileRepository(this.dio);

  Future<UserModel?> getProfile(int userId) async {
    final response = await dio.get(
      '${ApiEndpoints.customerProfile}/$userId',
    );

    final profile =
    ProfileResponseModel.fromJson(response.data);

    return profile.user;
  }

  Future<UserModel?> updateProfile({
    required int userId,
    required String name,
    String? phone,
    String? email,
  }) async {
    final response = await dio.put(
      '${ApiEndpoints.customerProfile}/$userId',
      data: {
        "name": name,
        if (phone != null) "phone": phone,
        if (email != null) "email": email,
      },
    );

    final profile =
    ProfileResponseModel.fromJson(response.data);

    return profile.user;
  }

  /// NEW: Upload avatar
  Future<UserModel?> updateAvatar({
    required int userId,
    required String filePath,
  }) async {
    final fileName = filePath.split('/').last;

    final formData = FormData.fromMap({
      "avatar": await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      ),
    });

    final response = await dio.post(
      '${ApiEndpoints.customerAvatar}/$userId',
      data: formData,
    );

    final profile =
    ProfileResponseModel.fromJson(response.data);

    return profile.user;
  }
}
