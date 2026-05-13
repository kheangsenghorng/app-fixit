import 'package:dio/dio.dart';

import '../../../../../core/constants/api_endpoints.dart';
import '../model/wallet_transaction_model.dart';



class WalletTransactionRepository {
  final Dio dio;

  WalletTransactionRepository(this.dio);

  Future<List<WalletTransaction>> getAll() async {
    try {
      final response = await dio.get(ApiEndpoints.walletTransactions);

      final json = response.data;

      if (json['data'] is List) {
        return (json['data'] as List)
            .map((e) => WalletTransaction.fromJson(e))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception("Failed to load wallet transactions");
    }
  }

  Future<WalletTransaction?> getById(int id) async {
    try {
      final response = await dio.get(
        ApiEndpoints.walletTransactionById(id),
      );

      final json = response.data;

      if (json['data'] == null) return null;

      return WalletTransaction.fromJson(json['data']);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception("Failed to load wallet transaction");
    }
  }

  Future<List<WalletTransaction>> getByUserId(int userId) async {
    try {
      final response = await dio.get(
        ApiEndpoints.walletTransactionsByUserId(userId),
      );

      final json = response.data;

      if (json['data'] is List) {
        return (json['data'] as List)
            .map((e) => WalletTransaction.fromJson(e))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception("Failed to load user wallet transactions");
    }
  }

  Future<List<WalletTransaction>> getByWalletId(int walletId) async {
    try {
      final response = await dio.get(
        ApiEndpoints.walletTransactionsByWalletId(walletId),
      );

      final json = response.data;

      if (json['data'] is List) {
        return (json['data'] as List)
            .map((e) => WalletTransaction.fromJson(e))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception("Failed to load wallet transactions");
    }
  }

  Future<WalletTransaction?> createWalletTransaction({
    required int walletId,
    required int userId,
    int? paymentId,
    int? serviceBookingId,
    required String type,
    String? method,
    String? transactionRef,
    String? externalTransactionId,
    required double amount,
    String? description,
  }) async {
    try {
      final response = await dio.post(
        ApiEndpoints.walletTransactions,
        data: {
          'wallet_id': walletId,
          'user_id': userId,
          'payment_id': paymentId,
          'service_booking_id': serviceBookingId,
          'type': type,
          'method': method,
          'transaction_ref': transactionRef,
          'external_transaction_id': externalTransactionId,
          'amount': amount,
          'description': description,
        },
      );

      final json = response.data;

      if (json['data'] == null) return null;

      return WalletTransaction.fromJson(json['data']);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception("Failed to create wallet transaction");
    }
  }

  String _handleDioError(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      if (data['message'] != null) {
        return data['message'].toString();
      }

      if (data['errors'] != null) {
        final errors = data['errors'];

        if (errors is Map) {
          return errors.values
              .map((value) {
            if (value is List) {
              return value.join(", ");
            }
            return value.toString();
          })
              .join("\n");
        }
      }
    }

    if (e.type == DioExceptionType.connectionTimeout) {
      return "Connection timeout";
    }

    if (e.type == DioExceptionType.receiveTimeout) {
      return "Receive timeout";
    }

    if (e.type == DioExceptionType.connectionError) {
      return "No internet connection or server not running";
    }

    return e.message ?? "Something went wrong";
  }
}