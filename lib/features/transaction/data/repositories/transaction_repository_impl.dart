import 'package:iampelgading/features/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:iampelgading/features/transaction/data/models/transaction_model.dart';
import 'package:iampelgading/features/transaction/domain/entities/transaction.dart';
import 'package:iampelgading/features/transaction/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Transaction>> getTransactions() async {
    try {
      final remoteTransactions = await remoteDataSource.getTransactions();
      return remoteTransactions;
    } catch (e) {
      throw Exception('Failed to get transactions: $e');
    }
  }

  @override
  Future<Transaction> addTransaction(Transaction transaction) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      final createdTransaction = await remoteDataSource.addTransaction(model);
      return createdTransaction;
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  @override
  Future<Transaction> updateTransaction(Transaction transaction) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      final updatedTransaction = await remoteDataSource.updateTransaction(
        model,
      );
      return updatedTransaction;
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      await remoteDataSource.deleteTransaction(id);
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }
}
