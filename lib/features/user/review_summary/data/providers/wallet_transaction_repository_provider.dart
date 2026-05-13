import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/network/dio_provider.dart';
import '../repositories/wallet_transaction_repository.dart';

final walletTransactionRepositoryProvider =
Provider<WalletTransactionRepository>((ref) {
  final dio = ref.read(dioProvider);
  return WalletTransactionRepository(dio);
});