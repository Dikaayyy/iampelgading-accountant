import 'package:iampelgading/features/transaction/domain/entities/transaction.dart';
import 'package:iampelgading/features/transaction/data/datasources/transaction_remote_datasource.dart';

abstract class TransactionRepository {
  Future<Transaction> addTransaction(Transaction transaction);
  Future<List<Transaction>> getTransactions();
  Future<PaginatedTransactionResponse> getTransactionsPaginated({
    int page = 1,
    int limit = 10,
    String? search,
  });
  Future<Transaction> updateTransaction(Transaction transaction);
  Future<void> deleteTransaction(String id);
}
