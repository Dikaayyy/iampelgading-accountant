import 'package:iampelgading/features/transaction/data/models/transaction_model.dart';
import 'package:iampelgading/features/transaction/domain/entities/transaction.dart';
import 'package:iampelgading/features/transaction/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  // For now, using in-memory storage
  final List<TransactionModel> _transactions = [];

  @override
  Future<void> addTransaction(Transaction transaction) async {
    final model = TransactionModel.fromEntity(transaction);
    final newModel = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: model.title,
      amount: model.amount,
      category: model.category,
      date: model.date,
      paymentMethod: model.paymentMethod,
      description: model.description,
      isIncome: model.isIncome,
      quantity: model.quantity,
      pricePerItem: model.pricePerItem,
    );
    _transactions.add(newModel);
  }

  @override
  Future<List<Transaction>> getTransactions() async {
    return _transactions;
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      _transactions[index] = TransactionModel.fromEntity(transaction);
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((t) => t.id == id);
  }
}
