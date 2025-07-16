import 'package:flutter/material.dart';
import 'package:iampelgading/features/transaction/presentation/providers/transaction_provider.dart';
import 'package:iampelgading/features/transaction/domain/entities/transaction.dart';

class DashboardProvider with ChangeNotifier {
  final TransactionProvider? _transactionProvider;

  bool _isLoading = false;
  String? _userName = 'Admin Iampelgading';

  DashboardProvider({TransactionProvider? transactionProvider})
    : _transactionProvider = transactionProvider;

  bool get isLoading => _isLoading;
  String? get userName => _userName;

  // Get real data from TransactionProvider
  double get totalIncome {
    if (_transactionProvider == null) return 0.0;

    return _transactionProvider.transactions
        .where((transaction) => transaction.isIncome)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  double get totalExpense {
    if (_transactionProvider == null) return 0.0;

    return _transactionProvider.transactions
        .where((transaction) => !transaction.isIncome)
        .fold(0.0, (sum, transaction) => sum + transaction.amount.abs());
  }

  double get netIncome => totalIncome - totalExpense;

  // Get recent transactions (last 5)
  List<Transaction> get recentTransactions {
    if (_transactionProvider == null) return [];

    final transactions = List<Transaction>.from(
      _transactionProvider.transactions,
    );
    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions.take(5).toList();
  }

  // Convert transactions to map format for UI compatibility
  List<Map<String, dynamic>> get recentTransactionsAsMap {
    return recentTransactions
        .map(
          (transaction) => _transactionProvider!.transactionToMap(transaction),
        )
        .toList();
  }

  Future<void> refreshDashboard() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Refresh transaction data
      if (_transactionProvider != null) {
        await _transactionProvider.refreshTransactions();
      }
    } catch (e) {
      // Handle error if needed
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateUserName(String? userName) {
    _userName = userName;
    notifyListeners();
  }
}
