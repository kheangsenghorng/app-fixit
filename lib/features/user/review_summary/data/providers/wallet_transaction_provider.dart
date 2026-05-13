import 'package:flutter/material.dart';


import '../model/wallet_transaction_model.dart';
import '../repositories/wallet_transaction_repository.dart';

class WalletTransactionProvider extends ChangeNotifier {
  final WalletTransactionRepository repository;

  WalletTransactionProvider(this.repository);

  bool _loading = false;
  String? _error;
  List<WalletTransaction> _transactions = [];
  WalletTransaction? _transaction;

  bool get loading => _loading;
  String? get error => _error;
  List<WalletTransaction> get transactions => _transactions;
  WalletTransaction? get transaction => _transaction;

  bool get isEmpty => !_loading && _transactions.isEmpty;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  Future<void> getAllTransactions() async {
    _setLoading(true);
    _setError(null);

    try {
      _transactions = await repository.getAll();
    } catch (e) {
      _transactions = [];
      _setError(e.toString().replaceFirst('Exception: ', ''));
    }

    _setLoading(false);
  }

  Future<void> getTransactionById(int id) async {
    _setLoading(true);
    _setError(null);

    try {
      _transaction = await repository.getById(id);
    } catch (e) {
      _transaction = null;
      _setError(e.toString().replaceFirst('Exception: ', ''));
    }

    _setLoading(false);
  }

  Future<void> getTransactionsByUserId(int userId) async {
    _setLoading(true);
    _setError(null);

    try {
      _transactions = await repository.getByUserId(userId);
    } catch (e) {
      _transactions = [];
      _setError(e.toString().replaceFirst('Exception: ', ''));
    }

    _setLoading(false);
  }

  Future<void> getTransactionsByWalletId(int walletId) async {
    _setLoading(true);
    _setError(null);

    try {
      _transactions = await repository.getByWalletId(walletId);
    } catch (e) {
      _transactions = [];
      _setError(e.toString().replaceFirst('Exception: ', ''));
    }

    _setLoading(false);
  }

  Future<bool> createWalletTransaction({
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
    _setLoading(true);
    _setError(null);

    try {
      final result = await repository.createWalletTransaction(
        walletId: walletId,
        userId: userId,
        paymentId: paymentId,
        serviceBookingId: serviceBookingId,
        type: type,
        method: method,
        transactionRef: transactionRef,
        externalTransactionId: externalTransactionId,
        amount: amount,
        description: description,
      );

      if (result != null) {
        _transaction = result;
        _transactions.insert(0, result);
        _setLoading(false);
        notifyListeners();
        return true;
      }

      _setError("Wallet transaction not created");
      _setLoading(false);
      return false;
    } catch (e) {
      _setError(e.toString().replaceFirst('Exception: ', ''));
      _setLoading(false);
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearData() {
    _transactions = [];
    _transaction = null;
    _error = null;
    notifyListeners();
  }
}