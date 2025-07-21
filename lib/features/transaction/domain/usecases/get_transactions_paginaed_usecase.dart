import 'package:iampelgading/features/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:iampelgading/features/transaction/domain/repositories/transaction_repository.dart';

class GetTransactionsPaginated {
  final TransactionRepository repository;

  GetTransactionsPaginated(this.repository);

  Future<PaginatedTransactionResponse> call({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    return await repository.getTransactionsPaginated(
      page: page,
      limit: limit,
      search: search,
    );
  }
}
