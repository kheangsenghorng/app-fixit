import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/network/dio_provider.dart';
import '../model/wallet_model.dart';
import '../repositories/wallet_repository.dart';

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return WalletRepository(dio);
});

final walletByUserIdProvider = FutureProvider.family<Wallet?, int>(
      (ref, userId) async {
    final repository = ref.watch(walletRepositoryProvider);

    final response = await repository.getWalletByUserId(userId);

    return response.data;
  },
);

final walletTopUpProvider =
StateNotifierProvider<WalletTopUpNotifier, AsyncValue<WalletResponse?>>(
      (ref) {
    final repository = ref.watch(walletRepositoryProvider);
    return WalletTopUpNotifier(repository, ref);
  },
);

class WalletTopUpNotifier extends StateNotifier<AsyncValue<WalletResponse?>> {
  final WalletRepository repository;
  final Ref ref;

  WalletTopUpNotifier(this.repository, this.ref)
      : super(const AsyncValue.data(null));

  Future<bool> topUpWallet({
    required int walletId,
    required int userId,
    required double amount,
    String? method,
    String? transactionRef,
    String? externalTransactionId,
    String? description,
  }) async {
    state = const AsyncValue.loading();

    try {
      final response = await repository.topUpWallet(
        walletId: walletId,
        amount: amount,
        method: method,
        transactionRef: transactionRef,
        externalTransactionId: externalTransactionId,
        description: description,
      );

      // Refresh wallet after deposit success
      ref.invalidate(walletByUserIdProvider(userId));

      state = AsyncValue.data(response);
      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }
}