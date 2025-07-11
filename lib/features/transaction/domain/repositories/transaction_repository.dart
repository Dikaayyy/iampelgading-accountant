import 'package:iampelgading/features/transaction/domain/entities/transaction.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(Transaction transaction);
  Future<List<Transaction>> getTransactions();
  Future<void> updateTransaction(Transaction transaction);
  Future<void> deleteTransaction(String id);
}
