import 'package:iampelgading/features/transaction/domain/entities/transaction.dart';
import 'package:iampelgading/features/transaction/domain/repositories/transaction_repository.dart';

class ExportTransactions {
  final TransactionRepository repository;

  ExportTransactions(this.repository);

  Future<List<Transaction>> call({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final transactions = await repository.getTransactions();

    // Filter transactions by date range
    return transactions.where((transaction) {
      final transactionDate = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );
      final start = DateTime(startDate.year, startDate.month, startDate.day);
      final end = DateTime(endDate.year, endDate.month, endDate.day);

      return transactionDate.isAfter(start.subtract(const Duration(days: 1))) &&
          transactionDate.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }
}
