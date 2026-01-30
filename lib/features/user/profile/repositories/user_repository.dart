import 'package:dio/dio.dart';

import '../model/profile_response_model.dart';


class UserRepository {
  final Dio dio;

  UserRepository(this.dio);

  Future<ProfileResponseModel> getProfile() async {
    final response = await dio.get('/me');
    return ProfileResponseModel.fromJson(response.data);
  }
}
