import 'package:iampelgading/features/transaction/domain/entities/transaction.dart';
import 'package:iampelgading/features/transaction/domain/repositories/transaction_repository.dart';

class AddTransaction {
  final TransactionRepository repository;

  AddTransaction(this.repository);

  Future<void> call(Transaction transaction) async {
    await repository.addTransaction(transaction);
  }
}
