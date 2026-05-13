import 'package:dio/dio.dart';


import '../../../../../../core/constants/api_endpoints.dart';
import '../model/wallet_model.dart';

class WalletRepository {
  final Dio dio;

  WalletRepository(this.dio);

  Future<WalletResponse> getWalletByUserId(int userId) async {
    try {
      final response = await dio.get(
        ApiEndpoints.walletByUserId(userId),
      );

      return WalletResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e));
    } catch (e) {
      throw Exception('Failed to get wallet');
    }
  }

  Future<WalletResponse> topUpWallet({
    required int walletId,
    required double amount,
    String? method,
    String? transactionRef,
    String? externalTransactionId,
    String? description,
  }) async {
    try {
      final response = await dio.post(
        ApiEndpoints.topUpWallet(walletId),
        data: {
          'amount': amount,
          if (method != null) 'method': method,
          if (transactionRef != null) 'transaction_ref': transactionRef,
          if (externalTransactionId != null)
            'external_transaction_id': externalTransactionId,
          if (description != null) 'description': description,
        },
      );

      return WalletResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_getErrorMessage(e));
    } catch (e) {
      throw Exception('Failed to top up wallet');
    }
  }
}

String _getErrorMessage(DioException error) {
  final data = error.response?.data;

  if (data is Map<String, dynamic>) {
    if (data['message'] != null) {
      return data['message'].toString();
    }

    if (data['errors'] != null) {
      return data['errors'].toString();
    }
  }

  return error.message ?? 'Something went wrong';
}