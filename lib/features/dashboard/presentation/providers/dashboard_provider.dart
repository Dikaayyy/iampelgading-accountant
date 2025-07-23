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

  // Get recent transactions (filtered by today's date only)
  List<Transaction> get recentTransactions {
    if (_transactionProvider == null) return [];

    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = DateTime(today.year, today.month, today.day, 23, 59, 59);

    final transactions =
        _transactionProvider.transactions
            .where(
              (transaction) =>
                  transaction.date.isAfter(
                    todayStart.subtract(Duration(seconds: 1)),
                  ) &&
                  transaction.date.isBefore(todayEnd.add(Duration(seconds: 1))),
            )
            .toList();

    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions.take(15).toList();
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
