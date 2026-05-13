import 'package:dio/dio.dart';

import '../../../../../core/constants/api_endpoints.dart';
import '../../../../../core/models/user_address_model.dart';
import '../../../../../core/storage/token_storage.dart';

class UserAddressService {
  final Dio dio;

  UserAddressService(this.dio);

  Future<Options> _authOptions() async {
    final token = await TokenStorage.get();

    return Options(
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty)
          'Authorization': 'Bearer $token',
      },
    );
  }

  String _getErrorMessage(
      DioException error, {
        String fallback = 'Something went wrong',
      }) {
    final data = error.response?.data;

    if (data is Map<String, dynamic>) {
      if (data['errors'] is Map) {
        final errors = data['errors'] as Map;

        return errors.values.map((value) {
          if (value is List) {
            return value.join('\n');
          }

          return value.toString();
        }).join('\n');
      }

      if (data['message'] != null) {
        return data['message'].toString();
      }
    }

    return error.message ?? fallback;
  }

  List<UserAddress> _parseAddressList(dynamic data) {
    if (data is Map<String, dynamic>) {
      final responseData = data['data'];

      if (responseData is List) {
        return responseData.map((item) {
          return UserAddress.fromJson(
            Map<String, dynamic>.from(item),
          );
        }).toList();
      }

      return [];
    }

    if (data is List) {
      return data.map((item) {
        return UserAddress.fromJson(
          Map<String, dynamic>.from(item),
        );
      }).toList();
    }

    return [];
  }

  UserAddress? _parseSingleAddress(dynamic data) {
    // Case 1:
    // {
    //   "success": true,
    //   "message": "...",
    //   "data": {...}
    // }
    if (data is Map<String, dynamic>) {
      final responseData = data['data'];

      if (responseData is Map<String, dynamic>) {
        return UserAddress.fromJson(responseData);
      }

      if (responseData is Map) {
        return UserAddress.fromJson(
          Map<String, dynamic>.from(responseData),
        );
      }

      // Case 2:
      // {
      //   "id": 1,
      //   "address": "..."
      // }
      if (data['id'] != null) {
        return UserAddress.fromJson(data);
      }
    }

    return null;
  }

  Future<List<UserAddress>> getAddresses() async {
    try {
      final response = await dio.get(
        ApiEndpoints.addresses,
        options: await _authOptions(),
      );

      return _parseAddressList(response.data);
    } on DioException catch (e) {
      throw Exception(
        _getErrorMessage(
          e,
          fallback: 'Failed to get addresses',
        ),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserAddress?> createAddress(UserAddress address) async {
    try {
      final response = await dio.post(
        ApiEndpoints.addresses,
        data: address.toCreateJson(),
        options: await _authOptions(),
      );
      return _parseSingleAddress(response.data);
    } on DioException catch (e) {
      throw Exception(
        _getErrorMessage(
          e,
          fallback: 'Failed to create address',
        ),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserAddress?> updateAddress({
    required int id,
    required UserAddress address,
  }) async {
    try {
      final response = await dio.put(
        ApiEndpoints.addressById(id),
        data: address.toUpdateJson(),
        options: await _authOptions(),
      );

      return _parseSingleAddress(response.data);
    } on DioException catch (e) {
      throw Exception(
        _getErrorMessage(
          e,
          fallback: 'Failed to update address',
        ),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> deleteAddress(int id) async {
    try {
      await dio.delete(
        ApiEndpoints.addressById(id),
        options: await _authOptions(),
      );

      return true;
    } on DioException catch (e) {
      throw Exception(
        _getErrorMessage(
          e,
          fallback: 'Failed to delete address',
        ),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}