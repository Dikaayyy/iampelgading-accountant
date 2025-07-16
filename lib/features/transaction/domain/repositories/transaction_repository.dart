import 'package:iampelgading/features/transaction/domain/entities/transaction.dart';

abstract class TransactionRepository {
  Future<Transaction> addTransaction(Transaction transaction);
  Future<List<Transaction>> getTransactions();
  Future<Transaction> updateTransaction(Transaction transaction);
  Future<void> deleteTransaction(String id);
}
